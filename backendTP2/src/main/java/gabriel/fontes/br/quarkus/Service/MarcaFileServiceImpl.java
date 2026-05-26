package gabriel.fontes.br.quarkus.Service;

import java.io.IOException;
import java.io.InputStream;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.HexFormat;
import java.nio.file.Paths;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.util.Locale;
import java.util.Set;
import java.util.UUID;

import org.jboss.resteasy.reactive.multipart.FileUpload;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import gabriel.fontes.br.quarkus.Model.Arquivo;
import gabriel.fontes.br.quarkus.Model.Marca;
import gabriel.fontes.br.quarkus.Repository.ArquivoRepository;
import gabriel.fontes.br.quarkus.Repository.MarcaRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.ws.rs.NotFoundException;
import jakarta.ws.rs.WebApplicationException;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.core.Response;
import org.eclipse.microprofile.config.inject.ConfigProperty;

@ApplicationScoped
public class MarcaFileServiceImpl implements MarcaFileService {
    private static final Set<String> ALLOWED_EXTENSIONS = Set.of("jpg", "jpeg", "png", "gif", "webp");
    private static final long MAX_FILE_SIZE = 5L * 1024 * 1024;
    private static final long MIN_FILE_SIZE = 1L * 1024;

    @Inject
    MarcaRepository marcaRepository;

    @Inject
    ArquivoRepository arquivoRepository;

    @Inject
    ObjectMapper objectMapper;

    @ConfigProperty(name = "seaweedfs.master.url", defaultValue = "http://localhost:9333")
    String masterUrl;

    @ConfigProperty(name = "seaweedfs.request-timeout-ms", defaultValue = "10000")
    int timeoutMs;

    private final HttpClient httpClient = HttpClient.newHttpClient();

    @Override
    @Transactional
    public void salvar(Long id, FileUpload file) throws IOException {
        Marca marca = marcaRepository.findById(id);
        if (marca == null) {
            throw new NotFoundException("Marca não encontrada.");
        }

        validarTamanho(file);
        validarExtensao(file);

        String fid = uploadParaSeaweed(file);
        Arquivo arquivo = buildArquivoEntity(file, fid);
        arquivoRepository.persist(arquivo);
        marca.addArquivo(arquivo);
    }

    private Arquivo buildArquivoEntity(FileUpload file, String fid) throws IOException {
        Arquivo arquivo = new Arquivo();
        arquivo.setFid(fid);

        String originalName = Paths.get(file.fileName()).getFileName().toString();
        arquivo.setNomeOriginal(originalName);

        String mimeType = file.contentType();
        if (mimeType == null || mimeType.isBlank()) {
            mimeType = guessMimeTypeByExtension(getExtension(originalName));
        }
        arquivo.setMimeType(mimeType == null ? "application/octet-stream" : mimeType);

        arquivo.setTamanhoBytes(file.size());
        arquivo.setSha256(sha256Hex(file.uploadedFile()));
        return arquivo;
    }

    private String uploadParaSeaweed(FileUpload file) throws IOException {
        String fileName = Paths.get(file.fileName()).getFileName().toString();
        String extension = getExtension(fileName);
        String normalizedName = UUID.randomUUID() + (extension == null ? "" : "." + extension.toLowerCase(Locale.ROOT));
        byte[] fileBytes = Files.readAllBytes(file.uploadedFile());

        JsonNode assignJson = requestJson("GET", masterUrl + "/dir/assign", null, null);
        String fid = text(assignJson, "fid");
        String volumeUrl = text(assignJson, "publicUrl");
        if (volumeUrl == null) {
            volumeUrl = text(assignJson, "url");
        }
        if (volumeUrl != null && (volumeUrl.contains("172.") || volumeUrl.contains("192.") || volumeUrl.contains("10."))) {
            volumeUrl = "localhost:8088";
        }

        if (fid == null || volumeUrl == null) {
            throw new WebApplicationException("Resposta inválida do SeaweedFS ao alocar arquivo.", Response.Status.BAD_GATEWAY);
        }

        String boundary = "----QuarkusSeaweedBoundary" + UUID.randomUUID();
        byte[] body = buildMultipartBody(boundary, normalizedName, file.contentType(), fileBytes);

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create("http://" + volumeUrl + "/" + fid))
                .timeout(java.time.Duration.ofMillis(timeoutMs))
                .header("Content-Type", "multipart/form-data; boundary=" + boundary)
                .POST(HttpRequest.BodyPublishers.ofByteArray(body))
                .build();

        HttpResponse<String> response;
        try {
            response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new IOException("Upload interrompido.", e);
        }

        if (response.statusCode() < 200 || response.statusCode() >= 300) {
            throw new WebApplicationException("Falha ao enviar imagem para o SeaweedFS.", Response.Status.BAD_GATEWAY);
        }

        return fid;
    }

    @Override
    @Transactional
    public void remover(String fid) {
        if (fid == null || fid.isBlank()) {
            throw new WebApplicationException("Identificador de imagem inválido.", Response.Status.BAD_REQUEST);
        }

        Arquivo arquivo = arquivoRepository.findByFid(fid)
                .orElseThrow(() -> new WebApplicationException("Imagem não encontrada no banco de dados.", Response.Status.NOT_FOUND));

        deletarNoSeaweedBestEffort(fid);
        // Remove the reference from Marca
        marcaRepository.find("select m from Marca m join m.arquivos a where a.id = ?1", arquivo.getId())
                .firstResultOptional()
                .ifPresent(marca -> marca.removeArquivo(arquivo));
        
        arquivoRepository.delete(arquivo);
    }

    private void deletarNoSeaweedBestEffort(String fid) {
        try {
            String volumeId = extractVolumeId(fid);
            JsonNode lookup = requestJson("GET", masterUrl + "/dir/lookup?volumeId=" + volumeId, null, null);
            JsonNode locations = lookup.get("locations");
            if (locations == null || !locations.isArray() || locations.isEmpty()) {
                return;
            }

            String publicUrl = text(locations.get(0), "publicUrl");
            if (publicUrl == null) {
                publicUrl = text(locations.get(0), "url");
            }

            if (publicUrl != null && (publicUrl.contains("172.") || publicUrl.contains("192.") || publicUrl.contains("10."))) {
                publicUrl = "localhost:8088";
            }

            if (publicUrl == null) {
                return;
            }

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create("http://" + publicUrl + "/" + fid))
                    .timeout(java.time.Duration.ofMillis(timeoutMs))
                    .DELETE()
                    .build();

            httpClient.send(request, HttpResponse.BodyHandlers.discarding());
        } catch (Exception ignored) {
        }
    }

    private JsonNode requestJson(String method, String url, String contentType, byte[] body) {
        HttpRequest.Builder builder = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .timeout(java.time.Duration.ofMillis(timeoutMs));

        if (contentType != null) {
            builder.header("Content-Type", contentType);
        }

        if ("POST".equalsIgnoreCase(method)) {
            builder.POST(HttpRequest.BodyPublishers.ofByteArray(body == null ? new byte[0] : body));
        } else if ("DELETE".equalsIgnoreCase(method)) {
            builder.DELETE();
        } else {
            builder.GET();
        }

        try {
            HttpResponse<String> response = httpClient.send(builder.build(), HttpResponse.BodyHandlers.ofString());
            if (response.statusCode() < 200 || response.statusCode() >= 300) {
                throw new WebApplicationException("Erro de comunicação com SeaweedFS.", Response.Status.BAD_GATEWAY);
            }
            return objectMapper.readTree(response.body());
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new WebApplicationException("Operação com SeaweedFS interrompida.", Response.Status.INTERNAL_SERVER_ERROR);
        } catch (IOException e) {
            throw new WebApplicationException("Erro ao processar resposta do SeaweedFS.", e, Response.Status.BAD_GATEWAY);
        }
    }

    private byte[] buildMultipartBody(String boundary, String fileName, String contentType, byte[] bytes) {
        String safeContentType = (contentType == null || contentType.isBlank()) ? "application/octet-stream" : contentType;

        byte[] prefix = (
                "--" + boundary + "\r\n" +
                "Content-Disposition: form-data; name=\"file\"; filename=\"" + fileName + "\"\r\n" +
                "Content-Type: " + safeContentType + "\r\n\r\n")
                .getBytes(StandardCharsets.UTF_8);

        byte[] suffix = ("\r\n--" + boundary + "--\r\n").getBytes(StandardCharsets.UTF_8);
        byte[] body = new byte[prefix.length + bytes.length + suffix.length];

        System.arraycopy(prefix, 0, body, 0, prefix.length);
        System.arraycopy(bytes, 0, body, prefix.length, bytes.length);
        System.arraycopy(suffix, 0, body, prefix.length + bytes.length, suffix.length);

        return body;
    }

    private void validarTamanho(FileUpload file) {
        if (file == null || file.uploadedFile() == null) {
            throw new WebApplicationException("Arquivo de imagem não informado.", Response.Status.BAD_REQUEST);
        }

        long size = file.size();
        if (size <= 0) {
            throw new WebApplicationException("Arquivo vazio.", Response.Status.BAD_REQUEST);
        }
        if (size < MIN_FILE_SIZE) {
            throw new WebApplicationException("Arquivo muito pequeno para ser considerado imagem válida.", Response.Status.BAD_REQUEST);
        }
        if (size > MAX_FILE_SIZE) {
            throw new WebApplicationException("Arquivo muito grande. Máximo permitido: " + MAX_FILE_SIZE + " bytes.", Response.Status.BAD_REQUEST);
        }
    }

    private void validarExtensao(FileUpload file) {
        String ext = getExtension(file.fileName());
        if (ext == null || !ALLOWED_EXTENSIONS.contains(ext.toLowerCase(Locale.ROOT))) {
            throw new WebApplicationException("Extensão de arquivo não suportada.", Response.Status.BAD_REQUEST);
        }
    }

    private String getExtension(String fileName) {
        if (fileName == null) {
            return null;
        }
        String onlyName = Paths.get(fileName).getFileName().toString();
        int idx = onlyName.lastIndexOf('.');
        if (idx == -1 || idx == onlyName.length() - 1) {
            return null;
        }
        return onlyName.substring(idx + 1);
    }

    private String extractVolumeId(String fid) {
        int comma = fid.indexOf(',');
        if (comma <= 0) {
            throw new WebApplicationException("FID inválido para lookup no SeaweedFS.", Response.Status.BAD_REQUEST);
        }
        return fid.substring(0, comma);
    }

    private String sha256Hex(java.nio.file.Path uploadedPath) throws IOException {
        try (InputStream is = Files.newInputStream(uploadedPath)) {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] buffer = new byte[8192];
            int n;
            while ((n = is.read(buffer)) > 0) {
                digest.update(buffer, 0, n);
            }
            return HexFormat.of().formatHex(digest.digest());
        } catch (NoSuchAlgorithmException e) {
            throw new IllegalStateException("SHA-256 não disponível na JVM.", e);
        }
    }

    private String guessMimeTypeByExtension(String ext) {
        if (ext == null) {
            return "application/octet-stream";
        }
        return switch (ext.toLowerCase(Locale.ROOT)) {
            case "png" -> "image/png";
            case "jpg", "jpeg" -> "image/jpeg";
            case "gif" -> "image/gif";
            case "webp" -> "image/webp";
            default -> "application/octet-stream";
        };
    }

    private String text(JsonNode node, String field) {
        JsonNode value = node.get(field);
        return value == null || value.isNull() ? null : value.asText();
    }
}
