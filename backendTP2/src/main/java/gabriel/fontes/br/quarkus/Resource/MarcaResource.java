package gabriel.fontes.br.quarkus.Resource;

import gabriel.fontes.br.quarkus.Dto.MarcaRequest;
import gabriel.fontes.br.quarkus.Dto.MarcaResponse;
import gabriel.fontes.br.quarkus.Service.MarcaService;
import jakarta.annotation.security.PermitAll;
import jakarta.annotation.security.RolesAllowed;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

import java.net.URI;
import java.util.List;
import java.util.logging.Logger;

@Path("/marca")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class MarcaResource {

    @Inject
    MarcaService service;

    private static final Logger logger = Logger.getLogger(ClienteResource.class.getName());

    @GET
    @PermitAll
    public Response findAll(@QueryParam("page") @DefaultValue("0") int page, 
                            @QueryParam("pageSize") @DefaultValue("10") int pageSize, 
                            @QueryParam("nome") String nome) {
        List<MarcaResponse> lista = service.findAll(page, pageSize, nome);
        logger.info("Buscando todas as marcas");
        return Response.ok(lista).build();
    }

    @GET
    @Path("/count")
    @PermitAll
    public Response count(@QueryParam("nome") String nome) {
        long total = service.count(nome);
        logger.info("Contando marcas - Total: " + total);
        return Response.ok(total).build();
    }

    @GET
    @Path("/{id}")
    @PermitAll
    public MarcaResponse findById(@PathParam("id") Long id) {
        logger.info("Buscando marca pelo ID: " + id);
        return service.findById(id);
    }

    @POST
    @Transactional
    @RolesAllowed("ADM") 
    public Response create(MarcaRequest request) {
        MarcaResponse response = service.create(request);
        logger.info("Marca criada: " + response.id());
        return Response.created(URI.create("/marcas/" + response.id())).entity(response).build();
    }

    @PUT
    @Path("/{id}")
    @Transactional
    @RolesAllowed("ADM")
    public MarcaResponse update(@PathParam("id") Long id, MarcaRequest request) {
        logger.info("Atualizando marca com ID: " + id);
        return service.update(id, request);
    }

    @DELETE
    @Path("/{id}")
    @Transactional
    @RolesAllowed("ADM")
    public Response delete(@PathParam("id") Long id) {
        MarcaResponse marcaDeletada = service.delete(id);
        logger.info("Marca deletada: " + marcaDeletada.id());
        return Response.ok(marcaDeletada).build();
    }
}