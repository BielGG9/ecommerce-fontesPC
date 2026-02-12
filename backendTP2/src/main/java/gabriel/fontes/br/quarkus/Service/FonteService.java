package gabriel.fontes.br.quarkus.Service;

import gabriel.fontes.br.quarkus.Dto.FonteRequest;
import gabriel.fontes.br.quarkus.Dto.FonteResponse;
import java.util.List;

public interface FonteService {

    // CRUD - Create, Read, Update, Delete
    FonteResponse create(FonteRequest dto);
    FonteResponse update(Long id, FonteRequest dto);
    FonteResponse delete(Long id);
    List<FonteResponse> findAll();
    FonteResponse findById(Long id);
}