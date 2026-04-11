package gabriel.fontes.br.quarkus.Service;

import gabriel.fontes.br.quarkus.Dto.MarcaRequest;
import gabriel.fontes.br.quarkus.Dto.MarcaResponse;
import java.util.List;

public interface MarcaService {

    // CRUD - Create, Read, Update, Delete
    MarcaResponse create(MarcaRequest dto);
    MarcaResponse update(Long id, MarcaRequest dto);
    MarcaResponse delete(Long id);
    List<MarcaResponse> findAll(int page, int pageSize, String nome);
    long count(String nome);
    MarcaResponse findById(Long id);
}