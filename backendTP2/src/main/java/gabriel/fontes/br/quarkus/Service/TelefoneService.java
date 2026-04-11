package gabriel.fontes.br.quarkus.Service;

import java.util.List;
import gabriel.fontes.br.quarkus.Dto.TelefoneRequest;
import gabriel.fontes.br.quarkus.Dto.TelefoneResponse;

public interface TelefoneService {

    // CRUD - Create, Read, Update, Delete
    TelefoneResponse findById(Long id);
    List<TelefoneResponse> findAll();
    TelefoneResponse delete(Long id);
    TelefoneResponse update(Long id, TelefoneRequest dto);
    TelefoneResponse create(TelefoneRequest dto);
}