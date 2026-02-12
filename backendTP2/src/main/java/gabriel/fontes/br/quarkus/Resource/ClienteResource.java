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

import gabriel.fontes.br.quarkus.Dto.ClienteRequest;
import gabriel.fontes.br.quarkus.Dto.ClienteResponse;
import gabriel.fontes.br.quarkus.Service.ClienteService;


@Path("/clientes")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class ClienteResource {

    @Inject
    ClienteService service;

    private static final Logger logger = Logger.getLogger(ClienteResource.class.getName());

    @GET
    @RolesAllowed({"USER", "ADM"})
    public List<ClienteResponse> findAll() {    
        logger.info("Buscando todos os clientes");
        return service.findAll();

    }

    @GET
    @Path("/meu-perfil")
    @RolesAllowed({"USER", "ADM"})
    public Response getMeuPerfil() {
        ClienteResponse meuPerfil = service.getMeuPerfil();
        logger.info("Buscando perfil do cliente logado");
        return Response.ok(meuPerfil).build();

    }

    @GET
    @Path("/{id}")
    @RolesAllowed({"USER", "ADM"})
    public ClienteResponse findById(@PathParam("id") Long id) {
        logger.info("Buscando cliente pelo ID: " + id);
        return service.findById(id);

    }

    @POST
    @Transactional
    @RolesAllowed({"USER", "ADM"})
    public Response create(ClienteRequest request) {
        ClienteResponse response = service.create(request);
        logger.info("Cliente criado: " + response.id());
        return Response.created(URI.create("/clientes/" + response.id())).entity(response).build();

    }

    @PUT
    @Path("/{id}")
    @Transactional
    @RolesAllowed("ADM")
    public ClienteResponse update(@PathParam("id")Long id, ClienteRequest request) {
        logger.info("Atualizando cliente com ID: " + id);
        return service.update(id, request);

    }

   @DELETE
@Path("/{id}")
@Transactional
@RolesAllowed("ADM")
public Response delete(@PathParam("id") Long id) {
    ClienteResponse clienteDeletado = service.delete(id);
    logger.info("Cliente deletado: " + clienteDeletado.id());
    return Response.noContent().build(); 
}
}
