package gabriel.fontes.br.quarkus.Repository;

import java.util.List;

import gabriel.fontes.br.quarkus.Model.Abstratc.Pagamento;
import io.quarkus.hibernate.orm.panache.PanacheRepository;
import jakarta.enterprise.context.ApplicationScoped;

@ApplicationScoped
public class PagamentoRepository implements PanacheRepository<Pagamento> {
    
    public List<Pagamento> findByStatus(String status) {
        return find("status", status).list();
    }
}
