package gabriel.fontes.br.quarkus.Resource;

import jakarta.annotation.security.PermitAll;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import gabriel.fontes.br.quarkus.Dto.CupomRequest;
import gabriel.fontes.br.quarkus.Dto.CupomResponse;
import gabriel.fontes.br.quarkus.Service.CupomService;

@Path("/cupons")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class CupomResource {

    @Inject
    CupomService cupomService;

    @POST
    @Path("/validar")
    @PermitAll
    public Response validar(CupomRequest request) {
        CupomResponse response = cupomService.validarCupom(request.codigo());
        return Response.ok(response).build();
    }
}
