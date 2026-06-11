package gabriel.fontes.br.quarkus.Service;

import java.io.IOException;
import java.io.InputStream;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.HexFormat;
import java.nio.file.Paths;
import java.nio.file.Files;
import java.util.Locale;
import java.util.Set;
import java.util.UUID;

import org.jboss.resteasy.reactive.multipart.FileUpload;

import gabriel.fontes.br.quarkus.Model.Arquivo;
import gabriel.fontes.br.quarkus.Model.Fonte;
import gabriel.fontes.br.quarkus.Repository.ArquivoRepository;
import gabriel.fontes.br.quarkus.Repository.FonteRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.ws.rs.NotFoundException;
import jakarta.ws.rs.WebApplicationException;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.core.Response;

@ApplicationScoped
public class FonteFileServiceImpl implements FileService {
    private static final Set<String> ALLOWED_EXTENSIONS = Set.of("jpg", "jpeg", "png", "gif", "webp");
    private static final long MAX_FILE_SIZE = 5L * 1024 * 1024;
    private static final long MIN_FILE_SIZE = 1L * 1024;

    @Inject
    FonteRepository fonteRepository;

    @Inject
    ArquivoRepository arquivoRepository;

    @Inject
    S3StorageService storageService;

    @Override
    @Transactional
    public void salvar(Long id, FileUpload file) throws IOException {
        Fonte fonte = fonteRepository.findById(id);
        if (fonte == null) {
            throw new NotFoundException("Fonte não encontrada.");
        }

        validarTamanho(file);
        validarExtensao(file);

        byte[] fileBytes = Files.readAllBytes(file.uploadedFile());
        String originalName = Paths.get(file.fileName()).getFileName().toString();
        String extension = getExtension(originalName);
        String fid = UUID.randomUUID().toString() + (extension == null ? "" : "." + extension.toLowerCase(Locale.ROOT));

        String mimeType = file.contentType();
        if (mimeType == null || mimeType.isBlank()) {
            mimeType = guessMimeTypeByExtension(extension);
        }

        // Realiza o upload no MinIO
        storageService.upload(fid, fileBytes, mimeType);

        // Cria a entidade de banco de dados
        Arquivo arquivo = buildArquivoEntity(file, fid);
        arquivoRepository.persist(arquivo);
        fonte.addArquivo(arquivo);
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

    @Override
    public ArquivoDownload download(String fid) {
        if (fid == null || fid.isBlank()) {
            throw new WebApplicationException("Identificador de imagem inválido.", Response.Status.BAD_REQUEST);
        }

        Arquivo meta = arquivoRepository.findByFid(fid)
                .orElseThrow(() -> new WebApplicationException("Imagem não encontrada no banco de dados.", Response.Status.NOT_FOUND));

        try {
            byte[] fileBytes = storageService.download(fid);
            return new ArquivoDownload(fileBytes, meta.getMimeType(), meta.getNomeOriginal());
        } catch (Exception e) {
            throw new WebApplicationException("Erro ao baixar imagem do armazenamento.", e, Response.Status.BAD_GATEWAY);
        }
    }

    @Override
    @Transactional
    public void remover(String fid) {
        if (fid == null || fid.isBlank()) {
            throw new WebApplicationException("Identificador de imagem inválido.", Response.Status.BAD_REQUEST);
        }

        Arquivo arquivo = arquivoRepository.findByFid(fid)
                .orElseThrow(() -> new WebApplicationException("Imagem não encontrada no banco de dados.", Response.Status.NOT_FOUND));

        // Deleta do MinIO
        storageService.delete(fid);

        // Remove a referência da Fonte
        fonteRepository.find("select f from Fonte f join f.arquivos a where a.id = ?1", arquivo.getId())
                .firstResultOptional()
                .ifPresent(fonte -> fonte.removeArquivo(arquivo));
        
        arquivoRepository.delete(arquivo);
    }

    private void validarTamanho(FileUpload file) {
        if (file == null || file.uploadedFile() == null) {
            throw new WebApplicationException(Response.status(Response.Status.BAD_REQUEST).entity("Arquivo de imagem não informado.").build());
        }

        long size = file.size();
        if (size <= 0) {
            throw new WebApplicationException(Response.status(Response.Status.BAD_REQUEST).entity("Arquivo vazio.").build());
        }
        if (size < MIN_FILE_SIZE) {
            throw new WebApplicationException(Response.status(Response.Status.BAD_REQUEST).entity("Arquivo muito pequeno para ser considerado imagem válida (mínimo de 1 KB).").build());
        }
        if (size > MAX_FILE_SIZE) {
            throw new WebApplicationException(Response.status(Response.Status.BAD_REQUEST).entity("Arquivo muito grande. Máximo permitido: 5 MB.").build());
        }
    }

    private void validarExtensao(FileUpload file) {
        String ext = getExtension(file.fileName());
        if (ext == null || !ALLOWED_EXTENSIONS.contains(ext.toLowerCase(Locale.ROOT))) {
            throw new WebApplicationException(Response.status(Response.Status.BAD_REQUEST).entity("Extensão de arquivo não suportada. Use jpg, jpeg, png, gif ou webp.").build());
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
}
