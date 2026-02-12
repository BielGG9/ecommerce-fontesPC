package gabriel.fontes.br.quarkus.Service;

import java.util.List;


import gabriel.fontes.br.quarkus.Dto.ModeloRequest;
import gabriel.fontes.br.quarkus.Dto.ModeloResponse;

public interface ModeloService {
    
    
    ModeloResponse create(ModeloRequest dto);
    ModeloResponse update(Long id, ModeloRequest dto);
    ModeloResponse delete(Long id);
    List<ModeloResponse> findAll();
    ModeloResponse findById(Long id);
}
