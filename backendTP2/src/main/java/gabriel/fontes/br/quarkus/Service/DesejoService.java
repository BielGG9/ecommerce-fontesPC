package gabriel.fontes.br.quarkus.Service;

import java.util.List;
import gabriel.fontes.br.quarkus.Dto.DesejoRequest;
import gabriel.fontes.br.quarkus.Dto.DesejoResponse;

public interface DesejoService {
    List<DesejoResponse> findMeusDesejos();
    DesejoResponse create(DesejoRequest request);
    void delete(Long idDesejo);
}
