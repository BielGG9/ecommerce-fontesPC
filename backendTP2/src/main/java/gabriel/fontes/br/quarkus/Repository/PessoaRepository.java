package gabriel.fontes.br.quarkus.Repository;

import gabriel.fontes.br.quarkus.Model.Abstratc.Pessoa;
import io.quarkus.hibernate.orm.panache.PanacheRepository;
import jakarta.enterprise.context.ApplicationScoped;

@ApplicationScoped
public class PessoaRepository implements PanacheRepository<Pessoa> {
    
    public Pessoa findByCpf(String cpf) {
        return find("cpf", cpf).firstResult();
    }
}
