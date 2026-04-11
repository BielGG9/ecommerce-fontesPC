package gabriel.fontes.br.quarkus.Resource;

import jakarta.annotation.security.RolesAllowed;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

import java.net.URI;
import java.util.List;
import java.util.logging.Logger;

import gabriel.fontes.br.quarkus.Dto.PedidoRequest;
import gabriel.fontes.br.quarkus.Dto.PedidoResponse;
import gabriel.fontes.br.quarkus.Service.PedidoService;


@Path("/pedidos")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class PedidoResource {

    @Inject
    PedidoService service;

    private static final Logger logger = Logger.getLogger(ClienteResource.class.getName());

    @GET
    @RolesAllowed({"USER", "ADM"})
    public List<PedidoResponse> findAll() {
        logger.info("Buscando todos os pedidos");
        return service.findAll();

    }

    @GET 
    @Path("/{id}")
    @RolesAllowed({"USER", "ADM"})
    public PedidoResponse findById(@PathParam("id") Long id) {
        logger.info("Buscando pedido pelo ID: " + id);
        return service.findById(id);
    }

    @GET
    @Path("/meus-pedidos")
    @RolesAllowed({"USER", "ADM"})
    public List<PedidoResponse> MeusPedidos() {
        List<PedidoResponse> pedidos = service.MeusPedidos();
        logger.info("Buscando meus pedidos");
        return pedidos;
    }

    @POST
    @Transactional
    @RolesAllowed({"USER", "ADM"})
    public Response create(PedidoRequest request) {
        PedidoResponse response = service.create(request);  
        logger.info("Pedido Criado: " + response.id());
        return Response.created(URI.create("/pedidos/" + response.id())).entity(response).build();
    }

    @PUT
    @Path("/{id}")
    @Transactional
    @RolesAllowed({"USER", "ADM"})
    public PedidoResponse update(@PathParam("id")Long id, PedidoRequest request) {
        logger.info("Pedido atualizada com ID: " + id );
        return service.update(id, request);
    }

    @DELETE
    @Path("/{id}")
    @Transactional
    @RolesAllowed("ADM")
    public PedidoResponse delete(@PathParam("id") Long id) {
        logger.info("Pedido deletada pelo ID: " + id);
        return service.delete(id);
    }

}
