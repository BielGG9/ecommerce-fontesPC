package gabriel.fontes.br.quarkus.Resource;

import jakarta.annotation.security.RolesAllowed;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import gabriel.fontes.br.quarkus.Dto.DesejoRequest;
import gabriel.fontes.br.quarkus.Dto.DesejoResponse;
import gabriel.fontes.br.quarkus.Service.DesejoService;

@Path("/desejos")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class DesejoResource {

    @Inject
    DesejoService desejoService;

    @GET
    @RolesAllowed({"USER", "ADM"})
    public Response findMeusDesejos() {
        return Response.ok(desejoService.findMeusDesejos()).build();
    }

    @POST
    @RolesAllowed({"USER", "ADM"})
    public Response create(DesejoRequest request) {
        DesejoResponse response = desejoService.create(request);
        return Response.status(Response.Status.CREATED)
                       .entity(response)
                       .build();
    }

    @DELETE
    @Path("/{id}")
    @RolesAllowed({"USER", "ADM"})
    public Response delete(@PathParam("id") Long id) {
        desejoService.delete(id);
        return Response.noContent().build();
    }
}
