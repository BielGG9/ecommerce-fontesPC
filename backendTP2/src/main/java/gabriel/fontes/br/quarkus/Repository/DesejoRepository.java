package gabriel.fontes.br.quarkus.Repository;

import java.util.List;
import java.util.Optional;

import gabriel.fontes.br.quarkus.Model.Desejo;
import io.quarkus.hibernate.orm.panache.PanacheRepository;
import jakarta.enterprise.context.ApplicationScoped;

@ApplicationScoped
public class DesejoRepository implements PanacheRepository<Desejo> {

    public Optional<Desejo> findByClienteAndFonte(Long idCliente, Long idFonte) {
        return find("cliente.id = ?1 AND fonte.id = ?2", idCliente, idFonte)
                .firstResultOptional();
    }

    public List<Desejo> findByCliente(Long idCliente) {
        return find("cliente.id = ?1", idCliente).list();
    }
}
