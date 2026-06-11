package gabriel.fontes.br.quarkus.Service;

import jakarta.annotation.PostConstruct;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import org.eclipse.microprofile.config.inject.ConfigProperty;
import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.*;

import java.util.logging.Logger;

@ApplicationScoped
public class S3StorageService {

    private static final Logger LOGGER = Logger.getLogger(S3StorageService.class.getName());

    @Inject
    S3Client s3;

    @ConfigProperty(name = "app.storage.bucket", defaultValue = "fontes-pc-images")
    String bucketName;

    @PostConstruct
    public void init() {
        try {
            // Verifica se o bucket existe
            s3.headBucket(HeadBucketRequest.builder().bucket(bucketName).build());
            LOGGER.info("Bucket " + bucketName + " já existe.");
        } catch (NoSuchBucketException e) {
            // Cria o bucket se não existir
            LOGGER.info("Criando bucket " + bucketName + "...");
            s3.createBucket(CreateBucketRequest.builder().bucket(bucketName).build());
            LOGGER.info("Bucket " + bucketName + " criado com sucesso.");
        } catch (Exception e) {
            LOGGER.severe("Erro ao verificar/criar o bucket no MinIO: " + e.getMessage());
        }
    }

    public String upload(String key, byte[] fileData, String contentType) {
        try {
            PutObjectRequest putRequest = PutObjectRequest.builder()
                    .bucket(bucketName)
                    .key(key)
                    .contentType(contentType)
                    .build();

            s3.putObject(putRequest, RequestBody.fromBytes(fileData));
            LOGGER.info("Arquivo " + key + " enviado para o bucket " + bucketName);
            return key;
        } catch (Exception e) {
            throw new RuntimeException("Erro ao fazer upload para o MinIO: " + e.getMessage(), e);
        }
    }

    public byte[] download(String key) {
        try {
            GetObjectRequest getRequest = GetObjectRequest.builder()
                    .bucket(bucketName)
                    .key(key)
                    .build();

            return s3.getObjectAsBytes(getRequest).asByteArray();
        } catch (Exception e) {
            throw new RuntimeException("Erro ao fazer download do MinIO: " + e.getMessage(), e);
        }
    }

    public void delete(String key) {
        try {
            DeleteObjectRequest deleteRequest = DeleteObjectRequest.builder()
                    .bucket(bucketName)
                    .key(key)
                    .build();

            s3.deleteObject(deleteRequest);
            LOGGER.info("Arquivo " + key + " removido do bucket " + bucketName);
        } catch (Exception e) {
            LOGGER.warning("Erro ao remover arquivo " + key + " do MinIO: " + e.getMessage());
        }
    }
}
