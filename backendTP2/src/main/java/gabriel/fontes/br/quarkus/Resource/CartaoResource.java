package gabriel.fontes.br.quarkus.Resource;

import gabriel.fontes.br.quarkus.Dto.CartaoRequest;
import gabriel.fontes.br.quarkus.Dto.CartaoResponse;
import gabriel.fontes.br.quarkus.Service.CartaoService;
import jakarta.annotation.security.RolesAllowed;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.net.URI;
import java.util.List;
import java.util.logging.Logger;

@Path("/cartoes")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class CartaoResource {

    @Inject
    CartaoService service;

    private static final Logger logger = Logger.getLogger(CartaoResource.class.getName());

    @POST
     @RolesAllowed({"USER", "ADM"})
    public Response create(CartaoRequest dto) {
        CartaoResponse response = service.create(dto);
        logger.info("Cartao criado: " + response.id());
        return Response.created(URI.create("/cartoes/" + response.id()))
                       .entity(response)
                       .build();
    }

    @GET
    @RolesAllowed({"USER", "ADM"})
    public List<CartaoResponse> findAll() {
        logger.info("Buscando todos os cartões");
        return service.findAll();
    }

    @GET
    @Path("/{id}")
    @RolesAllowed({"USER", "ADM"})
    public CartaoResponse findById(@PathParam("id") Long id) {
        logger.info("Buscando cartao pelo ID: " + id);
        return service.findById(id);
    }

    @PUT
    @Path("/{id}")
    @RolesAllowed("ADM")
    public CartaoResponse update(@PathParam("id") Long id, CartaoRequest dto) {
        logger.info("Atualizando cartao com ID: " + id);
        return service.update(id, dto);
    }

    @DELETE
    @Path("/{id}")
    @RolesAllowed("ADM")
    public Response delete(@PathParam("id") Long id) {
        CartaoResponse cartaoDeletado = service.delete(id);
        logger.info("Cartao deletado: " + cartaoDeletado.id());
        return Response.noContent().build();
    }
}