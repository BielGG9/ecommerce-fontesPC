package gabriel.fontes.br.quarkus.Repository;

import gabriel.fontes.br.quarkus.Model.Cartao;
import io.quarkus.hibernate.orm.panache.PanacheRepository;
import jakarta.enterprise.context.ApplicationScoped;

@ApplicationScoped
public class CartaoRepository implements PanacheRepository<Cartao> {
    

}
