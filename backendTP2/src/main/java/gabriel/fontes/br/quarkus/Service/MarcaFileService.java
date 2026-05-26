package gabriel.fontes.br.quarkus.Service;

import org.jboss.resteasy.reactive.multipart.FileUpload;
import java.io.IOException;

public interface MarcaFileService {
    void salvar(Long idMarca, FileUpload file) throws IOException;
    void remover(String fid);
}
