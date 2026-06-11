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
import gabriel.fontes.br.quarkus.Dto.CompletarCadastroDTO;
import gabriel.fontes.br.quarkus.Model.Endereco;
import gabriel.fontes.br.quarkus.Model.Telefone;
import gabriel.fontes.br.quarkus.Service.ClienteService;
import org.eclipse.microprofile.jwt.JsonWebToken;


@Path("/clientes")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class ClienteResource {

    @Inject
    ClienteService service;

    @Inject
    gabriel.fontes.br.quarkus.Repository.ClienteRepository clienteRepository;

    @Inject
    gabriel.fontes.br.quarkus.Service.KeycloakAdminService keycloakAdminService;

    @Inject
    JsonWebToken jwt;

    private static final Logger logger = Logger.getLogger(ClienteResource.class.getName());

    @POST
    @Path("/cadastro-expresso")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Transactional
    @PermitAll
    public Response cadastroExpresso(gabriel.fontes.br.quarkus.Dto.CadastroExpressoDTO dto) {
        // 1. Verificar se o cliente já existe no banco local por e-mail
        if (clienteRepository.findByEmail(dto.email()) != null) {
            return Response.status(Response.Status.CONFLICT)
                .entity(java.util.Map.of("message", "Já existe um cliente cadastrado com este e-mail."))
                .build();
        }

        // 2. Criar utilizador no Keycloak
        String cpfPadrao = "00000000000";
        String rgPadrao = "0000000";
        String idKeycloak = keycloakAdminService.criarUsuario(dto.email(), dto.nome(), dto.email(), dto.senha(), cpfPadrao, rgPadrao);

        // 3. Salvar o cliente localmente
        gabriel.fontes.br.quarkus.Model.Cliente cliente = new gabriel.fontes.br.quarkus.Model.Cliente();
        cliente.setNome(dto.nome());
        cliente.setEmail(dto.email());
        cliente.setSenha(dto.senha()); // Regra Absoluta: Salvando a senha em texto plano
        cliente.setCpf(cpfPadrao);
        cliente.setRg(rgPadrao);
        cliente.setIdKeycloak(idKeycloak);
        cliente.setDataCadastro(java.time.LocalDateTime.now());
        
        clienteRepository.persist(cliente);
        
        return Response.status(Response.Status.CREATED).entity(java.util.Map.of(
            "id", cliente.getId(),
            "nome", cliente.getNome(),
            "email", cliente.getEmail()
        )).build();
    }

    /**
     * PUT /clientes/completar-cadastro
     *
     * Recebe os dados de faturamento/entrega de um usuário cadastrado via
     * 'Cadastro Expresso' (que ainda não tem CPF real, endereço nem telefone).
     * Identifica o usuário pelo subject do token JWT.
     * Preenche apenas os campos que ainda estão nulos ou com valor padrão.
     * Exige role USER ou ADM.
     */
    @PUT
    @Path("/completar-cadastro")
    @Transactional
    @RolesAllowed({"USER", "ADM"})
    public Response completarCadastro(CompletarCadastroDTO dto) {
        String idKeycloak = jwt.getSubject();
        if (idKeycloak == null) {
            return Response.status(Response.Status.UNAUTHORIZED)
                    .entity(java.util.Map.of("message", "Usuário não autenticado."))
                    .build();
        }

        gabriel.fontes.br.quarkus.Model.Cliente cliente = clienteRepository.findByIdKeycloak(idKeycloak);
        if (cliente == null) {
            String email = jwt.getClaim("email");
            if (email != null) cliente = clienteRepository.findByEmail(email);
        }
        if (cliente == null) {
            return Response.status(Response.Status.NOT_FOUND)
                    .entity(java.util.Map.of("message", "Cliente não encontrado para o usuário autenticado."))
                    .build();
        }

        // Atualiza o CPF somente se ainda for o placeholder ou nulo
        if (dto.cpf() != null && !dto.cpf().isBlank()) {
            cliente.setCpf(dto.cpf().replaceAll("[^\\d]", ""));
        }

        // Persiste o endereço de entrega
        if (dto.cep() != null && !dto.cep().isBlank()) {
            Endereco endereco = new Endereco();
            endereco.setCep(dto.cep().replaceAll("[^\\d]", ""));
            endereco.setRua(dto.logradouro() != null ? dto.logradouro() : "");
            endereco.setNumero(dto.numero() != null ? dto.numero() : "S/N");
            endereco.setBairro("");
            endereco.setCidade("");
            endereco.setEstado("");
            endereco.setPessoa(cliente);
            if (cliente.getEnderecos() == null) {
                cliente.setEnderecos(new java.util.ArrayList<>());
            }
            cliente.getEnderecos().add(endereco);
        }

        // Persiste o telefone
        if (dto.telefone() != null && !dto.telefone().isBlank()) {
            String numeroBruto = dto.telefone().replaceAll("[^\\d]", "");
            Telefone tel = new Telefone();
            if (numeroBruto.length() > 2) {
                tel.setDdd(numeroBruto.substring(0, 2));
                tel.setNumero(numeroBruto.substring(2));
            } else {
                tel.setDdd("");
                tel.setNumero(numeroBruto);
            }
            tel.setPessoa(cliente);
            if (cliente.getTelefones() == null) {
                cliente.setTelefones(new java.util.ArrayList<>());
            }
            cliente.getTelefones().add(tel);
        }

        clienteRepository.persist(cliente);
        logger.info("Cadastro completado para cliente: " + cliente.getEmail());

        return Response.ok(ClienteResponse.fromEntity(cliente)).build();
    }

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
        try {
            service.recuperarSenha(request.email());
            return Response.ok(java.util.Map.of("message", "E-mail enviado com sucesso!")).build();
        } catch (jakarta.ws.rs.NotFoundException e) {
            logger.warning("E-mail para recuperação não encontrado no Keycloak: " + request.email());
            return Response.status(Response.Status.NOT_FOUND)
                .entity(java.util.Map.of("message", "E-mail não encontrado no sistema."))
                .build();
        } catch (WebApplicationException e) {
            logger.severe("Erro de aplicação ao recuperar senha: " + e.getMessage());
            int status = e.getResponse() != null ? e.getResponse().getStatus() : 500;
            return Response.status(status)
                .entity(java.util.Map.of("message", e.getMessage() != null ? e.getMessage() : "Erro no servidor de autenticação."))
                .build();
        } catch (Exception e) {
            logger.severe("Erro inesperado ao recuperar senha: " + e.getMessage());
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(java.util.Map.of("message", "Erro ao tentar processar a solicitação: " + e.getMessage()))
                .build();
        }
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
