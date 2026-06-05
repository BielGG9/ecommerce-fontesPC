package gabriel.fontes.br.quarkus.Service;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import software.amazon.awssdk.services.s3.S3Client;

@ApplicationScoped
public class S3StorageService {

    @Inject
    S3Client s3;

    public String uploadAvatar(String fileName, byte[] fileData, String contentType) {
        // Lógica de upload será implementada na próxima fase
        return "";
    }
}
