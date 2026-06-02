package gabriel.fontes.br.quarkus.Repository;

import java.util.Optional;

import gabriel.fontes.br.quarkus.Model.Cupom;
import io.quarkus.hibernate.orm.panache.PanacheRepository;
import jakarta.enterprise.context.ApplicationScoped;

@ApplicationScoped
public class CupomRepository implements PanacheRepository<Cupom> {

    public Optional<Cupom> findByCodigo(String codigo) {
        return find("codigo = ?1", codigo).firstResultOptional();
    }
}
