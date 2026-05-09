package gabriel.fontes.br.quarkus.Repository;

import gabriel.fontes.br.quarkus.Model.Arquivo;
import io.quarkus.hibernate.orm.panache.PanacheRepository;
import jakarta.enterprise.context.ApplicationScoped;
import java.util.Optional;

@ApplicationScoped
public class ArquivoRepository implements PanacheRepository<Arquivo> {
    public Optional<Arquivo> findByFid(String fid) {
        return find("fid", fid).firstResultOptional();
    }
}
