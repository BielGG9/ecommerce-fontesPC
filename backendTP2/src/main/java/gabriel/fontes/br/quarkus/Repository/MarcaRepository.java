package gabriel.fontes.br.quarkus.Repository;

import java.util.List;
import java.util.Optional; 

import gabriel.fontes.br.quarkus.Model.Marca;
import io.quarkus.hibernate.orm.panache.PanacheRepository;
import jakarta.enterprise.context.ApplicationScoped;

@ApplicationScoped
public class MarcaRepository implements PanacheRepository<Marca> {

    
    public Optional<Marca> findByNomeExato(String nome) {
        return find("nome", nome).firstResultOptional();
    }

    public List<Marca> findByNomeContendo(String texto) {
        String parametroDeBusca = "%" + texto.toUpperCase() + "%"; // Adicionamos os '%' e convertemos para maiúsculo
                return find("upper(nome) LIKE ?1", parametroDeBusca).list();
    }
}