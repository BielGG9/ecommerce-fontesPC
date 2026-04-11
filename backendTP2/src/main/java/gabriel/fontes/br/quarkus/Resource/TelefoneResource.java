package gabriel.fontes.br.quarkus.Resource;

import gabriel.fontes.br.quarkus.Service.TelefoneService;
import gabriel.fontes.br.quarkus.Dto.TelefoneRequest;
import gabriel.fontes.br.quarkus.Dto.TelefoneResponse;
import jakarta.annotation.security.RolesAllowed;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.util.List;
import java.util.logging.Logger;

@Path("/telefones")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class TelefoneResource {

    @Inject
    TelefoneService service;

    private static final Logger logger = Logger.getLogger(ClienteResource.class.getName());

    @POST
    @Transactional
    @RolesAllowed("ADM")
    public Response create(TelefoneRequest telefoneRequest) {
        TelefoneResponse telefoneCriado = service.create(telefoneRequest);
        return Response.status(Response.Status.CREATED).entity(telefoneCriado).build();
    }

    @GET
    @RolesAllowed({"USER", "ADM"})
    public Response findAll() {
        List<TelefoneResponse> lista = service.findAll();
        logger.info("Buscando todos os telefones" + lista);
        return Response.ok(lista).build();
    }
    
    @GET
    @Path("/{id}")
    @RolesAllowed({"USER", "ADM"})
    public Response findById(@PathParam("id") Long id) {
        TelefoneResponse telefone = service.findById(id);
        logger.info("Buscando telefone por ID: " + telefone);
        return Response.ok(telefone).build();
    }

    @DELETE
    @Path("/{id}")
    @Transactional
    @RolesAllowed("ADM")
    public Response delete(@PathParam("id") Long id) {
        TelefoneResponse telefoneDeletado = service.delete(id);
        logger.info("Delentendo telefone: " + telefoneDeletado);
        return Response.ok(telefoneDeletado).build();
    }

    @PUT
    @Path("/{id}")
    @Transactional
    @RolesAllowed("ADM")
    public Response update(@PathParam("id") Long id, TelefoneRequest telefoneRequest) {
        TelefoneResponse telefoneAtualizado = service.update(id, telefoneRequest);
        logger.info("Atualizando telefone: " + telefoneAtualizado);
        return Response.ok(telefoneAtualizado).build();
    }
}