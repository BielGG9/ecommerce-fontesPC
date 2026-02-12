package gabriel.fontes.br.quarkus.Repository;

import java.util.List;
import java.util.Optional;

import gabriel.fontes.br.quarkus.Model.Telefone;
import io.quarkus.hibernate.orm.panache.PanacheRepository;
import jakarta.enterprise.context.ApplicationScoped;

@ApplicationScoped
public class TelefoneRepository implements PanacheRepository<Telefone> {
    
     
    public List<Telefone> FindByTelefone(String texto) {
        String parametroDeBusca = "%" + texto.toUpperCase() + "%"; 
                return find("upper(numero) LIKE ?1", parametroDeBusca).list();
    
    }
}
