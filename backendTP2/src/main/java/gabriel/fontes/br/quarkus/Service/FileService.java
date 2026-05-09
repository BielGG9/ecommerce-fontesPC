package gabriel.fontes.br.quarkus.Service;

import org.jboss.resteasy.reactive.multipart.FileUpload;
import java.io.IOException;

public interface FileService {
    void salvar(Long idFonte, FileUpload file) throws IOException;
    ArquivoDownload download(String fid);
    void remover(String fid);
}
