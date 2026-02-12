package gabriel.fontes.br.quarkus.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import gabriel.fontes.br.quarkus.Model.Endereco;
import gabriel.fontes.br.quarkus.Model.Pedido;
import io.quarkus.hibernate.orm.panache.PanacheRepository;
import jakarta.enterprise.context.ApplicationScoped;

@ApplicationScoped
public class PedidoRepository implements PanacheRepository<Pedido> {
    
    public List<Pedido> findByUsuarioId(String usuarioId) {
        return find("idUsuario", usuarioId).list();
    }

    public Optional<Endereco> findByIdUsuario(String idUser) {
        throw new UnsupportedOperationException("Unimplemented method 'findByIdUsuario'");
    }
    
    public List<Pedido> buscarPorFiltros(String nomeCliente, Long fonteId, Long itensPedidoId) {
        Map<String, Object> params = new HashMap<>();
        
        StringBuilder query = new StringBuilder("FROM Pedido p WHERE 1=1"); 

        if (nomeCliente != null && !nomeCliente.isBlank()) {
            query.append(" AND LOWER(p.nomeClienteSnapshot) LIKE LOWER(:nome)");
            params.put("nome", "%" + nomeCliente + "%");
        }

        if (fonteId != null) {
            query.append(" AND EXISTS (SELECT i FROM ItemPedido i WHERE i.pedido.id = p.id AND i.fonte.id = :fonteId)");
            params.put("fonteId", fonteId);
        }

        if (itensPedidoId != null) {
            query.append(" AND EXISTS (SELECT i FROM ItemPedido i WHERE i.pedido.id = p.id AND i.id = :itensPedidoId)");
            params.put("itensPedidoId", itensPedidoId);
        }

        return find(query.toString(), params).list();
    }

    
}
