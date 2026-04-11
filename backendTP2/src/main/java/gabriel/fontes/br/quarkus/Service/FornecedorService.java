package gabriel.fontes.br.quarkus.Service;

import java.util.List;

import gabriel.fontes.br.quarkus.Dto.FornecedorRequest;
import gabriel.fontes.br.quarkus.Dto.FornecedorResponse;



public interface FornecedorService {

    // CRUD - Create, Read, Update, Delete
    FornecedorResponse create(FornecedorRequest dto);
    FornecedorResponse update(Long id, FornecedorRequest dto);
    FornecedorResponse delete(Long id);
    List<FornecedorResponse> findAll(int page, int pageSize, String nome);
    long count(String nome);
    FornecedorResponse findById(Long id);
    
}
