package gabriel.fontes.br.quarkus.Resource;


import gabriel.fontes.br.quarkus.Service.EnderecoService;
import gabriel.fontes.br.quarkus.Dto.EnderecoRequest;
import gabriel.fontes.br.quarkus.Dto.EnderecoResponse;
import jakarta.annotation.security.RolesAllowed;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.util.List;
import java.util.logging.Logger;

@Path("/enderecos")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class EnderecoResource {

    @Inject
    EnderecoService service;

    private static final Logger logger = Logger.getLogger(ClienteResource.class.getName());

    @POST
    @Transactional
    @RolesAllowed({"USER", "ADM"})
    public Response create(EnderecoRequest enderecoRequest) {
        EnderecoResponse enderecoCriado = service.create(enderecoRequest);
        logger.info("Endereço criado: " + enderecoCriado.id());
        return Response.status(Response.Status.CREATED).entity(enderecoCriado).build();
    }

    @GET
    @RolesAllowed({"USER", "ADM"})
    public Response findAll() {

        List<EnderecoResponse> lista = service.findAll();
        logger.info("Buscando todos os endereços");
        return Response.ok(lista).build();
    }
    
    @GET
    @Path("/{id}")
    @RolesAllowed({"USER", "ADM"})
    public Response findById(@PathParam("id") Long id) {
        EnderecoResponse endereco = service.findById(id);
        logger.info("Buscando endereço pelo ID: " + id);
        return Response.ok(endereco).build();
    }

    @DELETE
    @Path("/{id}")
    @Transactional
    @RolesAllowed("ADM")
    public Response delete(@PathParam("id") Long id) {
        EnderecoResponse enderecoDeletado = service.delete(id);
        logger.info("Endereço deletado: " + enderecoDeletado.id());
        return Response.ok(enderecoDeletado).build();
    }

    @PUT
    @Path("/{id}")
    @Transactional
    @RolesAllowed("ADM")
    public Response update(@PathParam("id") Long id, EnderecoRequest enderecoRequest) {
        EnderecoResponse enderecoAtualizado = service.update(id, enderecoRequest);
        logger.info("Endereço atualizado: " + enderecoAtualizado.id());
        return Response.ok(enderecoAtualizado).build();
    }
}