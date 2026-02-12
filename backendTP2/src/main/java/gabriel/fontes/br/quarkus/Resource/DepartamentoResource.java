package gabriel.fontes.br.quarkus.Resource;

import gabriel.fontes.br.quarkus.Service.DepartamentoService;
import gabriel.fontes.br.quarkus.Dto.DepartamentoRequest;
import gabriel.fontes.br.quarkus.Dto.DepartamentoResponse;
import jakarta.annotation.security.RolesAllowed;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.util.List;
import java.util.logging.Logger;

@Path("/departamentos")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class DepartamentoResource {

     
    @Inject
    DepartamentoService service;

    private static final Logger logger = Logger.getLogger(ClienteResource.class.getName());

    @POST
    @Transactional
    @RolesAllowed("ADM")
    public Response create(DepartamentoRequest departamentoRequest) {
        DepartamentoResponse departamentoCriado = service.create(departamentoRequest);
        logger.info("Departamento criado: " + departamentoCriado.id());
        return Response.status(Response.Status.CREATED).entity(departamentoCriado).build();
    }

    @GET
    @RolesAllowed({"USER", "ADM"})
    public Response findAll() {
        List<DepartamentoResponse> lista = service.findAll();
        logger.info("Buscando todos os departamentos");
        return Response.ok(lista).build();
    }
    
    @GET
    @Path("/{id}")
    @RolesAllowed({"USER", "ADM"})
    public Response finById(@PathParam("id") Long id) {
        DepartamentoResponse departamento = service.findById(id);
        logger.info("Buscando departamento pelo ID: " + id);
        return Response.ok(departamento).build();
    }

    @DELETE
    @Path("/{id}")
    @Transactional
    @RolesAllowed("ADM")
    public Response delete(@PathParam("id") Long id) {
        DepartamentoResponse departamentoDeletado = service.delete(id);
        logger.info("Departamento deletado: " + departamentoDeletado.id());
        return Response.noContent().build();
    }

    @PUT
    @Path("/{id}")
    @Transactional
    @RolesAllowed("ADM")
    public Response update(@PathParam("id") Long id, DepartamentoRequest departamentoRequest) {
        DepartamentoResponse departamentoAtualizado = service.update(id, departamentoRequest);
        logger.info("Departamento atualizado: " + departamentoAtualizado.id());
        return Response.ok(departamentoAtualizado).build();
    }
}