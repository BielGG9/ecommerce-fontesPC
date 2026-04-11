package gabriel.fontes.br.quarkus.Service;

import java.util.List;


import gabriel.fontes.br.quarkus.Dto.ModeloRequest;
import gabriel.fontes.br.quarkus.Dto.ModeloResponse;

public interface ModeloService {
    
    
    ModeloResponse create(ModeloRequest dto);
    ModeloResponse update(Long id, ModeloRequest dto);
    ModeloResponse delete(Long id);
    List<ModeloResponse> findAll(int page, int pageSize, String nome);
    long count(String nome);
    ModeloResponse findById(Long id);
}
