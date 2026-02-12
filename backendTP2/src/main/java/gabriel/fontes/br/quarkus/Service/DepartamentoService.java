package gabriel.fontes.br.quarkus.Service;

import java.util.List;

import gabriel.fontes.br.quarkus.Dto.DepartamentoRequest;
import gabriel.fontes.br.quarkus.Dto.DepartamentoResponse;


public interface DepartamentoService {

    // CRUD - Create, Read, Update, Delete
    DepartamentoResponse create(DepartamentoRequest dto);
    DepartamentoResponse update(Long id, DepartamentoRequest dto);
    DepartamentoResponse delete(Long id);
    List<DepartamentoResponse> findAll();
    DepartamentoResponse findById(Long id);

}

