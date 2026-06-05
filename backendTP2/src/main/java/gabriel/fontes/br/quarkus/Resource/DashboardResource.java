package gabriel.fontes.br.quarkus.Resource;

import gabriel.fontes.br.quarkus.Dto.DashboardResponse;
import gabriel.fontes.br.quarkus.Repository.ClienteRepository;
import gabriel.fontes.br.quarkus.Repository.FonteRepository;
import gabriel.fontes.br.quarkus.Repository.MarcaRepository;
import gabriel.fontes.br.quarkus.Repository.PedidoRepository;
import jakarta.annotation.security.RolesAllowed;
import jakarta.inject.Inject;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Path("/admin/dashboard")
@Produces(MediaType.APPLICATION_JSON)
public class DashboardResource {

    @Inject
    FonteRepository fonteRepository;

    @Inject
    MarcaRepository marcaRepository;

    @Inject
    ClienteRepository clienteRepository;

    @Inject
    PedidoRepository pedidoRepository;

    @GET
    @RolesAllowed("ADM")
    public DashboardResponse getEstatisticas() {
        Long totalFontes = fonteRepository.count();
        Long totalMarcas = marcaRepository.count();

        LocalDateTime inicioDia = LocalDate.now().atStartOfDay();
        LocalDateTime fimDia = LocalDate.now().plusDays(1).atStartOfDay();

        Double vendasDiarias = pedidoRepository.getEntityManager()
                .createQuery("SELECT SUM(p.total) FROM Pedido p WHERE p.data >= :inicioDia AND p.data < :fimDia", Double.class)
                .setParameter("inicioDia", inicioDia)
                .setParameter("fimDia", fimDia)
                .getSingleResult();

        if (vendasDiarias == null) {
            vendasDiarias = 0.0;
        }

        Long quantidadeVendasDiarias = pedidoRepository.getEntityManager()
                .createQuery("SELECT COUNT(p) FROM Pedido p WHERE p.data >= :inicioDia AND p.data < :fimDia", Long.class)
                .setParameter("inicioDia", inicioDia)
                .setParameter("fimDia", fimDia)
                .getSingleResult();

        return new DashboardResponse(totalFontes, totalMarcas, vendasDiarias, quantidadeVendasDiarias);
    }
}
