package gabriel.fontes.br.quarkus.Resource;


import gabriel.fontes.br.quarkus.Service.EnderecoService;
import gabriel.fontes.br.quarkus.Dto.EnderecoRequest;
import gabriel.fontes.br.quarkus.Dto.EnderecoResponse;
import jakarta.annotation.security.RolesAllowed;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.util.List;
import java.util.logging.Logger;

@Path("/enderecos")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class EnderecoResource {

    @Inject
    EnderecoService service;

    @Inject
    gabriel.fontes.br.quarkus.Repository.EnderecoRepository repoEnd;

    @Inject
    gabriel.fontes.br.quarkus.Repository.CartaoRepository repoCartao;

    @Inject
    gabriel.fontes.br.quarkus.Repository.PedidoRepository repoPedido;

    @GET
    @Path("/debug")
    @jakarta.annotation.security.PermitAll
    public Response debug() {
        java.util.List<java.util.Map<String, Object>> ends = repoEnd.listAll().stream().map(e -> {
            java.util.Map<String, Object> map = new java.util.HashMap<>();
            map.put("id", e.getId());
            map.put("rua", e.getRua());
            map.put("salvo", e.getSalvo());
            map.put("pessoaId", e.getPessoa() != null ? e.getPessoa().getId() : null);
            map.put("pessoaKeycloak", e.getPessoa() != null ? e.getPessoa().getIdKeycloak() : null);
            return map;
        }).collect(java.util.stream.Collectors.toList());

        java.util.List<java.util.Map<String, Object>> cards = repoCartao.listAll().stream().map(c -> {
            java.util.Map<String, Object> map = new java.util.HashMap<>();
            map.put("id", c.getId());
            map.put("numero", c.getNumeroCartao());
            map.put("salvo", c.getSalvo());
            map.put("clienteId", c.getCliente() != null ? c.getCliente().getId() : null);
            map.put("clienteKeycloak", c.getCliente() != null ? c.getCliente().getIdKeycloak() : null);
            return map;
        }).collect(java.util.stream.Collectors.toList());

        java.util.List<java.util.Map<String, Object>> peds = repoPedido.listAll().stream().map(p -> {
            java.util.Map<String, Object> map = new java.util.HashMap<>();
            map.put("id", p.getId());
            map.put("clienteId", p.getCliente() != null ? p.getCliente().getId() : null);
            map.put("clienteKeycloak", p.getCliente() != null ? p.getCliente().getIdKeycloak() : null);
            map.put("pagamentoId", p.getPagamento() != null ? p.getPagamento().getId() : null);
            map.put("cartaoId", p.getCartao() != null ? p.getCartao().getId() : null);
            return map;
        }).collect(java.util.stream.Collectors.toList());

        return Response.ok(java.util.Map.of("enderecos", ends, "cartoes", cards, "pedidos", peds)).build();
    }

    private static final Logger logger = Logger.getLogger(ClienteResource.class.getName());

    @POST
    @Transactional
    @RolesAllowed({"USER", "ADM"})
    public Response create(EnderecoRequest enderecoRequest) {
        try {
            EnderecoResponse enderecoCriado = service.create(enderecoRequest);
            logger.info("Endereço criado: " + enderecoCriado.id());
            return Response.status(Response.Status.CREATED).entity(enderecoCriado).build();
        } catch (Exception e) {
            e.printStackTrace();
            return Response.serverError().entity("ERRO INTERNO NO ENDEREÇO: " + e.getMessage() + " | Causa: " + (e.getCause() != null ? e.getCause().getMessage() : "null")).build();
        }
    }

    @GET
    @Path("/meus")
    @RolesAllowed({"USER", "ADM"})
    public Response findMeusEnderecos() {
        return Response.ok(service.findMeusEnderecos()).build();
    }

    @GET
    @RolesAllowed({"USER", "ADM"})
    public Response findAll() {

        List<EnderecoResponse> lista = service.findAll();
        logger.info("Buscando todos os endereços");
        return Response.ok(lista).build();
    }
    
    @GET
    @Path("/{id}")
    @RolesAllowed({"USER", "ADM"})
    public Response findById(@PathParam("id") Long id) {
        EnderecoResponse endereco = service.findById(id);
        logger.info("Buscando endereço pelo ID: " + id);
        return Response.ok(endereco).build();
    }

    @DELETE
    @Path("/{id}")
    @Transactional
    @RolesAllowed({"USER", "ADM"})
    public Response delete(@PathParam("id") Long id) {
        EnderecoResponse enderecoDeletado = service.delete(id);
        logger.info("Endereço deletado: " + enderecoDeletado.id());
        return Response.ok(enderecoDeletado).build();
    }

    @PUT
    @Path("/{id}")
    @Transactional
    @RolesAllowed({"USER", "ADM"})
    public Response update(@PathParam("id") Long id, EnderecoRequest enderecoRequest) {
        EnderecoResponse enderecoAtualizado = service.update(id, enderecoRequest);
        logger.info("Endereço atualizado: " + enderecoAtualizado.id());
        return Response.ok(enderecoAtualizado).build();
    }
}