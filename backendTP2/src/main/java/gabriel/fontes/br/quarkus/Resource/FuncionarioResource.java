package gabriel.fontes.br.quarkus.Resource;


import gabriel.fontes.br.quarkus.Service.FuncionarioService;
import gabriel.fontes.br.quarkus.Dto.FuncionarioRequest;
import gabriel.fontes.br.quarkus.Dto.FuncionarioResponse;
import jakarta.annotation.security.RolesAllowed;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.util.List;
import java.util.logging.Logger;

@Path("/funcionarios")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class FuncionarioResource {

    @Inject
    FuncionarioService service;

    private static final Logger logger = Logger.getLogger(ClienteResource.class.getName());

    @POST
    @Transactional
    @RolesAllowed("ADM")
    public Response create(FuncionarioRequest funcionarioRequest) {
        FuncionarioResponse funcionarioCriado = service.create(funcionarioRequest);
        logger.info("Funcionario criado: " + funcionarioCriado.id());
        return Response.status(Response.Status.CREATED).entity(funcionarioCriado).build();
    }

    @GET
    @RolesAllowed({"USER", "ADM"})
    public Response findAll() {
        List<FuncionarioResponse> lista = service.findAll();
        logger.info("Buscando todos os funcionarios");
        return Response.ok(lista).build();
    }
    
    @GET
    @Path("/{id}")
    @RolesAllowed({"USER", "ADM"})
    public Response findById(@PathParam("id") Long id) {
        FuncionarioResponse funcionario = service.findById(id);
        logger.info("Buscando funcionario pelo ID: " + id);
        return Response.ok(funcionario).build();
    }

    @DELETE
    @Path("/{id}")
    @Transactional
    @RolesAllowed("ADM")
    public Response delete(@PathParam("id") Long id) {
        FuncionarioResponse funcionarioDeletado = service.delete(id);
        logger.info("Funcionario deletado: " + funcionarioDeletado.id());
        return Response.ok(funcionarioDeletado).build();
    }

    @PUT
    @Path("/{id}")
    @Transactional
    @RolesAllowed("ADM")
    public Response update(@PathParam("id") Long id, FuncionarioRequest funcionarioRequest) {   
        FuncionarioResponse funcionarioAtualizado = service.update(id, funcionarioRequest);
        logger.info("Funcionario atualizado: " + funcionarioAtualizado.id());
        return Response.ok(funcionarioAtualizado).build();
    }
}