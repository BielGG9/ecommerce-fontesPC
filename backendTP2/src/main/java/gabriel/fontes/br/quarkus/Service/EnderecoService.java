// gabriel/fontes/br/quarkus/Service/EnderecoService.java
package gabriel.fontes.br.quarkus.Service;

import java.util.List;
import gabriel.fontes.br.quarkus.Dto.EnderecoRequest;
import gabriel.fontes.br.quarkus.Dto.EnderecoResponse;

public interface EnderecoService {

    // CRUD - Create, Read, Update, Delete
    EnderecoResponse create(EnderecoRequest dto);
    EnderecoResponse update(Long id, EnderecoRequest dto);
    EnderecoResponse delete(Long id);
    List<EnderecoResponse> findAll();
    EnderecoResponse findById(Long id);
    
}