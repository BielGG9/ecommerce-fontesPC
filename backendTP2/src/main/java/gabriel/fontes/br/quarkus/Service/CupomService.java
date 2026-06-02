package gabriel.fontes.br.quarkus.Service;

import gabriel.fontes.br.quarkus.Dto.CupomResponse;

public interface CupomService {
    CupomResponse validarCupom(String codigo);
}
