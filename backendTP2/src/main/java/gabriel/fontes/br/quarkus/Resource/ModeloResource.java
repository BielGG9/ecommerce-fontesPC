package gabriel.fontes.br.quarkus.Resource;

import gabriel.fontes.br.quarkus.Dto.ModeloRequest;
import gabriel.fontes.br.quarkus.Dto.ModeloResponse;
import gabriel.fontes.br.quarkus.Service.ModeloService;
import jakarta.annotation.security.RolesAllowed;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

import java.net.URI;
import java.util.List;
import java.util.logging.Logger;

@Path("/modelos")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)

public class ModeloResource {

    @Inject
    ModeloService service;

    private static final Logger logger = Logger.getLogger(ClienteResource.class.getName());

    @GET
    @RolesAllowed({"USER", "ADM"})
    public List<ModeloResponse> findAll() {
        logger.info("Buscando todos os modelos");
        return service.findAll();
    }

    @GET
    @Path("/{id}")
    @RolesAllowed({"USER", "ADM"})
    public ModeloResponse findById(@PathParam("id") Long id) {
        logger.info("Buscando modelo pelo ID: " + id);
        return service.findById(id);
    }

    @POST
    @Transactional
    @RolesAllowed("ADM")
    public Response create(ModeloRequest request) {
        ModeloResponse response = service.create(request);
        logger.info("Modelo criado: " + response.id());
        return Response.created(URI.create("/modelos/" + response.id())).entity(response).build();
    }

    @PUT
    @Path("/{id}")
    @Transactional
    @RolesAllowed("ADM")
    public ModeloResponse update(@PathParam("id") Long id, ModeloRequest request) {
        logger.info("Atualizando modelo com ID: " + id);
        return service.update(id, request);
    }

    @DELETE
    @Path("/{id}")
    @Transactional
    @RolesAllowed("ADM")
    public Response delete(@PathParam("id") Long id) {
        ModeloResponse modeloDeletado = service.delete(id);
        logger.info("Modelo deletado: " + modeloDeletado.id());
        return Response.ok(modeloDeletado).build();
    }
}