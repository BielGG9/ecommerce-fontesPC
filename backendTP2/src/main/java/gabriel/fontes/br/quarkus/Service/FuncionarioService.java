package gabriel.fontes.br.quarkus.Service;

import java.util.List;

import gabriel.fontes.br.quarkus.Dto.FuncionarioRequest;
import gabriel.fontes.br.quarkus.Dto.FuncionarioResponse;

public interface FuncionarioService {

    // CRUD - Create, Read, Update, Delete
    FuncionarioResponse create(FuncionarioRequest dto);
    FuncionarioResponse update(Long id, FuncionarioRequest dto);
    FuncionarioResponse delete(Long id);
    List<FuncionarioResponse> findAll();
    FuncionarioResponse findById(Long id);
    
}
