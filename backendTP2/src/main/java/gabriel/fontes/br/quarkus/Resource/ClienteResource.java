package gabriel.fontes.br.quarkus.Resource;

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

import gabriel.fontes.br.quarkus.Dto.AlteraSenhaRequest;
import gabriel.fontes.br.quarkus.Dto.ClienteRequest;
import gabriel.fontes.br.quarkus.Dto.ClienteResponse;
import gabriel.fontes.br.quarkus.Service.ClienteService;


@Path("/clientes")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class ClienteResource {

    @Inject
    ClienteService service;

    private static final Logger logger = Logger.getLogger(ClienteResource.class.getName());

    @GET
    @PermitAll
    public List<ClienteResponse> findAll() {    
        logger.info("Buscando todos os clientes");
        return service.findAll();

    }

    @GET
    @Path("/meu-perfil")
    @PermitAll
    public Response getMeuPerfil() {
        ClienteResponse meuPerfil = service.getMeuPerfil();
        logger.info("Buscando perfil do cliente logado");
        return Response.ok(meuPerfil).build();

    }

    @GET
    @Path("/{id}")
    @PermitAll
    public ClienteResponse findById(@PathParam("id") Long id) {
        logger.info("Buscando cliente pelo ID: " + id);
        return service.findById(id);

    }

    public record EsqueciSenhaRequest(String email) {}

    @POST
    @Path("/esqueci-senha")
    @PermitAll
    public Response esqueciSenha(EsqueciSenhaRequest request) {
        service.recuperarSenha(request.email());
        return Response.ok().build();
    }

    @POST
    @Transactional
    @PermitAll
    public Response create(ClienteRequest request) {
        ClienteResponse response = service.create(request);
        logger.info("Cliente criado: " + response.id());
        return Response.created(URI.create("/clientes/" + response.id())).entity(response).build();
    }

    @PUT
    @Path("/{id}")
    @Transactional
    @PermitAll
    public ClienteResponse update(@PathParam("id")Long id, ClienteRequest request) {
        logger.info("Atualizando cliente com ID: " + id);
        return service.update(id, request);

    }

   @DELETE
@Path("/{id}")
@Transactional
@RolesAllowed("ADM")
public Response delete(@PathParam("id") Long id) {
    ClienteResponse clienteDeletado = service.delete(id);
    logger.info("Cliente deletado: " + clienteDeletado.id());
    return Response.noContent().build(); 
}

    public record SolicitarAlteracaoRequest(String senha) {}

    @POST
    @Path("/solicitar-alteracao-segura")
    @PermitAll
    public Response solicitarAlteracaoSegura(SolicitarAlteracaoRequest request) {
        service.solicitarAlteracaoSegura(request.senha());
        return Response.ok(java.util.Map.of("message", "E-mail de verificação enviado!")).build();
    }

    /**
     * POST /clientes/alterar-senha
     *
     * Endpoint protegido para o usuário logado alterar sua própria senha.
     * Requer a senha atual para autenticar a operação antes de aplicar a nova.
     * O ID do usuário é extraído do token JWT — nenhum ID de rota é necessário.
     */
    @POST
    @Path("/alterar-senha")
    @RolesAllowed({"USER", "ADM"})
    public Response alterarSenha(@jakarta.validation.Valid AlteraSenhaRequest request) {
        try {
            service.alterarSenha(request.senhaAtual(), request.novaSenha());
            return Response.noContent().build(); // 204 No Content
        } catch (jakarta.ws.rs.WebApplicationException e) {
            if (e.getResponse().getStatus() == Response.Status.UNAUTHORIZED.getStatusCode() || 
                e.getResponse().getStatus() == 400) {
                return Response.status(Response.Status.BAD_REQUEST)
                        .entity(java.util.Map.of("message", "Senha atual incorreta. Verifique e tente novamente."))
                        .build(); // 400 Bad Request
            }
            throw e;
        } catch (Exception e) {
            logger.severe("Erro inesperado ao alterar senha: " + e.getMessage());
            return Response.status(500)
                    .entity(java.util.Map.of("message", "Ocorreu um erro interno. Por favor, tente novamente."))
                    .build();
        }
    }
}
