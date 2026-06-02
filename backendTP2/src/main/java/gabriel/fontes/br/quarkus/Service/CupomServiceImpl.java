package gabriel.fontes.br.quarkus.Service;

import gabriel.fontes.br.quarkus.Dto.CupomResponse;
import gabriel.fontes.br.quarkus.Repository.CupomRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;

@ApplicationScoped
public class CupomServiceImpl implements CupomService {

    @Inject
    CupomRepository cupomRepository;

    @Override
    public CupomResponse validarCupom(String codigo) {
        return cupomRepository.findByCodigo(codigo)
                .map(c -> new CupomResponse(
                        c.getCodigo(),
                        c.getPorcentagem(),
                        c.getAtivo()
                ))
                .orElse(new CupomResponse(codigo, null, false));
    }
}
