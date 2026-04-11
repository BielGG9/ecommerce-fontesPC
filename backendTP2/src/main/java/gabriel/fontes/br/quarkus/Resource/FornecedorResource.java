package gabriel.fontes.br.quarkus.Resource;


import gabriel.fontes.br.quarkus.Service.FornecedorService;
import gabriel.fontes.br.quarkus.Dto.FornecedorRequest;
import gabriel.fontes.br.quarkus.Dto.FornecedorResponse;
import jakarta.annotation.security.PermitAll;
import jakarta.annotation.security.RolesAllowed;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.util.List;
import java.util.logging.Logger;

@Path("/fornecedores")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class FornecedorResource {

    @Inject
    FornecedorService service;

    private static final Logger logger = Logger.getLogger(ClienteResource.class.getName());

    @POST
    @Transactional
    @RolesAllowed("ADM")
    public Response create(FornecedorRequest fornecedorRequest) {
        FornecedorResponse fornecedorCriado = service.create(fornecedorRequest);
        logger.info("Fornecedor criado: " + fornecedorCriado.id());
        return Response.status(Response.Status.CREATED).entity(fornecedorCriado).build();
    }

    @GET
    @PermitAll
    public Response findAll(@QueryParam("page") @DefaultValue("0") int page, 
                            @QueryParam("pageSize") @DefaultValue("10") int pageSize, 
                            @QueryParam("nome") String nome) {
        List<FornecedorResponse> lista = service.findAll(page, pageSize, nome);
        logger.info("Buscando todos os fornecedores");
        return Response.ok(lista).build();
    }

    @GET
    @Path("/count")
    @PermitAll
    public Response count(@QueryParam("nome") String nome) {
        long total = service.count(nome);
        logger.info("Contando fornecedores - Total: " + total);
        return Response.ok(total).build();
    }
    
    @GET
    @Path("/{id}")
    @PermitAll
    public Response findById(@PathParam("id") Long id) {
        FornecedorResponse fornecedor = service.findById(id);
        logger.info("Buscando fornecedor pelo ID: " + id);
        return Response.ok(fornecedor).build();
    }

    @DELETE
    @Path("/{id}")
    @Transactional
    @RolesAllowed("ADM")
    public Response delete(@PathParam("id") Long id) {
        FornecedorResponse fornecedorDeletado = service.delete(id);
        logger.info("Fornecedor deletado: " + fornecedorDeletado.id());
        return Response.ok(fornecedorDeletado).build();
    }

    @PUT
    @Path("/{id}")
    @Transactional
    @RolesAllowed("ADM")
    public Response update(@PathParam("id") Long id, FornecedorRequest fornecedorRequest) {
        FornecedorResponse fornecedorAtualizado = service.update(id, fornecedorRequest);
        logger.info("Fornecedor atualizado: " + fornecedorAtualizado.id());
        return Response.ok(fornecedorAtualizado).build();
    }
}