package gabriel.fontes.br.quarkus.Resource;

import gabriel.fontes.br.quarkus.Service.FonteService;
import gabriel.fontes.br.quarkus.Dto.FonteRequest;
import gabriel.fontes.br.quarkus.Dto.FonteResponse;
import jakarta.annotation.security.PermitAll;
import jakarta.annotation.security.RolesAllowed;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.util.List;
import java.util.logging.Logger;

@Path("/fontes")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class FonteResource {

    @Inject
    FonteService service;

    private static final Logger logger = Logger.getLogger(ClienteResource.class.getName());

    @POST
    @Transactional
    @RolesAllowed("ADM")
    public Response cadastrarFonte(FonteRequest fonteRequest) {
        FonteResponse fonteCriada = service.create(fonteRequest);
        logger.info("Fonte criada: " + fonteCriada.id());
        return Response.status(Response.Status.CREATED).entity(fonteCriada).build();
    }

    @GET
    @PermitAll
    public Response FindAll(@QueryParam("page") @DefaultValue("0") int page, 
                            @QueryParam("pageSize") @DefaultValue("10") int pageSize, 
                            @QueryParam("nome") String nome) {
        List<FonteResponse> lista = service.findAll(page, pageSize, nome);
        logger.info("Buscando todas as fontes (Página: " + page + ", Tamanho: " + pageSize + ", Busca: " + nome + ")");
        return Response.ok(lista).build();
    }

    @GET
    @Path("/count")
    @PermitAll
    public Response count(@QueryParam("nome") String nome) {
        long total = service.count(nome);
        logger.info("Contando fontes (Busca: " + nome + ") - Total: " + total);
        return Response.ok(total).build();
    }

    @GET
    @Path("/{id}")
    @PermitAll
    public Response findById(@PathParam("id") Long id) {
        FonteResponse fonte = service.findById(id);
        logger.info("Buscando fonte pelo ID: " + id);
        return Response.ok(fonte).build();
    }

    @DELETE
    @Path("/{id}")
    @Transactional
    @RolesAllowed("ADM")
    public Response delete(@PathParam("id") Long id) {
        FonteResponse fonteDeletada = service.delete(id);
        logger.info("Fonte deletada: " + fonteDeletada.id());
        return Response.ok(fonteDeletada).build();
    }

    @PUT
    @Path("/{id}")
    @Transactional
    @RolesAllowed("ADM")
    public Response update(@PathParam("id") Long id, FonteRequest fonteRequest) {
        FonteResponse fonteAtualizada = service.update(id, fonteRequest);
        logger.info("Fonte atualizada: " + fonteAtualizada.id());
        return Response.ok(fonteAtualizada).build();
    }
}