package gabriel.fontes.br.quarkus.Service;

import gabriel.fontes.br.quarkus.Dto.ClienteRequest;
import gabriel.fontes.br.quarkus.Dto.ClienteResponse;
import gabriel.fontes.br.quarkus.Model.Cliente;
import gabriel.fontes.br.quarkus.Repository.ClienteRepository;
import io.quarkus.security.ForbiddenException;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.NotFoundException;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

import org.eclipse.microprofile.jwt.JsonWebToken;

@ApplicationScoped
public class ClienteServiceImpl implements ClienteService {

    @Inject
    ClienteRepository repository;

    @Inject
    JsonWebToken jwt;
    
    @Inject
    KeycloakAdminService keycloakAdminService;


    /**
     * Busca clientes cujo nome contenha o termo informado (case insensitive)
     */
    public List<ClienteResponse> buscarClientesPorNome(String termoDeBusca) {
        List<Cliente> clientesEncontrados = repository.findByNomeContendo(termoDeBusca);
        return clientesEncontrados.stream()
                .map(ClienteResponse::fromEntity)
                .collect(Collectors.toList());
    }

    /**
     * Retorna o perfil do cliente logado com base no ID do Keycloak presente no token.
     * Caso o usuário já esteja cadastrado como cliente, lança ForbiddenException.
     */
    @Override
    @Transactional
    public ClienteResponse getMeuPerfil() {
        String idUsuarioKeycloak = jwt.getSubject();
        String emailUsuario = jwt.getClaim("email");

        // Busca cliente atrelado ao ID do Keycloak
        Cliente cliente = repository.findByIdKeycloak(idUsuarioKeycloak);

        // Fallback: se não achar pelo ID, tenta pelo e-mail
        if (cliente == null && emailUsuario != null) {
            cliente = repository.findByEmail(emailUsuario);
            
            if (cliente == null) {
                // Sincronização automática: O usuário existe no Keycloak mas sumiu do Postgres (ex: drop-and-create)
                Cliente novoCliente = new Cliente();
                novoCliente.setNome(jwt.getName() != null ? jwt.getName() : "Usuário " + emailUsuario);
                novoCliente.setEmail(emailUsuario);

                // Tenta extrair CPF e RG das claims personalizadas do JWT (com fallback robusto)
                String cpfClaim = jwt.getClaim("cpf");
                String rgClaim = jwt.getClaim("rg");

                if (cpfClaim == null && jwt.containsClaim("attributes")) {
                    Object attribs = jwt.getClaim("attributes");
                    if (attribs instanceof jakarta.json.JsonObject) {
                        jakarta.json.JsonObject attributesJson = (jakarta.json.JsonObject) attribs;
                        jakarta.json.JsonArray cpfArray = attributesJson.getJsonArray("cpf");
                        if (cpfArray != null && !cpfArray.isEmpty()) {
                            cpfClaim = cpfArray.getString(0);
                        }
                        jakarta.json.JsonArray rgArray = attributesJson.getJsonArray("rg");
                        if (rgArray != null && !rgArray.isEmpty()) {
                            rgClaim = rgArray.getString(0);
                        }
                    }
                }

                novoCliente.setCpf(cpfClaim != null ? cpfClaim : "00000000000");
                novoCliente.setRg(rgClaim != null ? rgClaim : "0000000");

                novoCliente.setIdKeycloak(idUsuarioKeycloak);
                novoCliente.setDataCadastro(LocalDateTime.now());
                repository.persist(novoCliente);
                cliente = novoCliente;
            } else if (cliente.getIdKeycloak() == null) {
                // Atualiza o idKeycloak para consertar o registro antigo
                cliente.setIdKeycloak(idUsuarioKeycloak);
                repository.persist(cliente);
            }
        }

        if (cliente == null) {
            throw new NotFoundException("Cliente não encontrado para o usuário autenticado.");
        }

        return ClienteResponse.fromEntity(cliente);
    }

    /**
     * Apenas imprime dados do token (debug)
     */
    public void imprimirDadosToken() {
        String idUsuarioKeycloak = jwt.getSubject();
        String nomeUsuario = jwt.getName();
        String emailUsuario = jwt.getClaim("email");

        System.out.println("ID do Usuário Keycloak: " + idUsuarioKeycloak);
        System.out.println("Nome do Usuário: " + nomeUsuario);
        System.out.println("Email do Usuário: " + emailUsuario);
    }

    /**
     * Cria um cliente novo.
     * - Impedir duplicidades por Email ou CPF
     * - Chama a criação no Keycloak primeiro
     * - Persiste a entidade na base local
     */
    @Override
    @Transactional
    public ClienteResponse create(ClienteRequest dto) {

        // 1. Nova Verificação de Duplicidade (usando metodos fictícios ou do Panache)
        // Nota: Assuma que o seu ClienteRepository possui estes métodos.
        boolean emailExiste = repository.findByEmail(dto.email()) != null;
        boolean nomeExiste = repository.findByNomeExato(dto.nome()).isPresent();

        if (emailExiste && nomeExiste) {
            throw new jakarta.ws.rs.WebApplicationException(
                jakarta.ws.rs.core.Response.status(409).entity(java.util.Map.of("message", "E-mail e Nome já cadastrados no sistema.")).build()
            );
        } else if (emailExiste) {
            throw new jakarta.ws.rs.WebApplicationException(
                jakarta.ws.rs.core.Response.status(409).entity(java.util.Map.of("message", "Já existe um cliente cadastrado com este e-mail.")).build()
            );
        } else if (nomeExiste) {
            throw new jakarta.ws.rs.WebApplicationException(
                jakarta.ws.rs.core.Response.status(409).entity(java.util.Map.of("message", "Já existe um cliente cadastrado com este nome.")).build()
            );
        }

        if (repository.findByCpf(dto.cpf()) != null) {
            throw new jakarta.ws.rs.WebApplicationException(
                jakarta.ws.rs.core.Response.status(409).entity(java.util.Map.of("message", "Já existe um cliente cadastrado com este CPF.")).build()
            );
        }

        // 2. Ordem Correta: PRIMEIRO cria no Keycloak
        String idKeycloak = keycloakAdminService.criarUsuario(dto.username(), dto.nome(), dto.email(), dto.senha(), dto.cpf(), dto.rg());

        // 3. Ordem Correta: SEGUNDO instanciar e popular
        Cliente novoCliente = new Cliente();
        novoCliente.setNome(dto.nome());
        novoCliente.setEmail(dto.email());
        novoCliente.setCpf(dto.cpf());
        novoCliente.setRg(dto.rg());
        novoCliente.setDataCadastro(LocalDateTime.now());
        novoCliente.setIdKeycloak(idKeycloak); // Salva o ID real do Keycloak na base de dados

        // 4. Ordem Correta: TERCEIRO persistir
        repository.persist(novoCliente);

        return ClienteResponse.fromEntity(novoCliente);
    }

    /**
     * Atualiza os dados de um cliente existente.
     */
    @Override
    @Transactional
    public ClienteResponse update(Long id, ClienteRequest dto) {
        Cliente cliente = repository.findByIdOptional(id)
                .orElseThrow(() -> new NotFoundException("Cliente com id " + id + " não encontrado."));

        cliente.setNome(dto.nome());
        cliente.setEmail(dto.email());
        cliente.setCpf(dto.cpf());
        cliente.setRg(dto.rg());
        cliente.setDataCadastro(LocalDateTime.now());

        return ClienteResponse.fromEntity(cliente);
    }

    /**
     * Deleta um cliente pelo ID e retorna o DTO deletado.
     */
    @Override
    @Transactional
    public ClienteResponse delete(Long id) {
        Cliente clienteExistente = repository.findByIdOptional(id)
                .orElseThrow(() -> new NotFoundException("Cliente com ID " + id + " não encontrado para exclusão."));

        // Converte antes de deletar, para retorno
        ClienteResponse resposta = ClienteResponse.fromEntity(clienteExistente);

        repository.delete(clienteExistente);

        return resposta;
    }

    /**
     * Retorna todos os clientes cadastrados
     */
    @Override
    public List<ClienteResponse> findAll() {
        return repository.listAll().stream()
                .map(ClienteResponse::fromEntity)
                .collect(Collectors.toList());
    }

    /**
     * Busca cliente pelo ID
     */
    @Override
    public ClienteResponse findById(Long id) {
        Cliente cliente = repository.findByIdOptional(id)
                .orElseThrow(() -> new NotFoundException("Cliente com id " + id + " não encontrado."));

        return ClienteResponse.fromEntity(cliente);
    }

    @Override
    public void recuperarSenha(String email) {
        keycloakAdminService.enviarEmailRecuperacaoSenha(email);
    }

    @Override
    public void solicitarAlteracaoSegura(String senha) {
        String emailUsuario = jwt.getClaim("email");
        String usernameUsuario = jwt.getClaim("preferred_username");

        if (emailUsuario == null || usernameUsuario == null) {
            throw new jakarta.ws.rs.NotAuthorizedException("Usuário não autenticado.");
        }

        boolean senhaValida = keycloakAdminService.validarSenhaUsuario(usernameUsuario, senha);
        if (!senhaValida) {
            throw new jakarta.ws.rs.WebApplicationException(
                jakarta.ws.rs.core.Response.status(401).entity(java.util.Map.of("message", "Senha incorreta. Não foi possível validar a sua identidade.")).build()
            );
        }

        keycloakAdminService.enviarEmailVerificacao(emailUsuario);
    }

    @Override
    public void alterarSenha(String senhaAtual, String novaSenha) {
        // Extrai identificadores do token JWT do usuário logado
        String userId = jwt.getSubject();
        String usernameUsuario = jwt.getClaim("preferred_username");

        if (userId == null || usernameUsuario == null) {
            throw new jakarta.ws.rs.NotAuthorizedException("Usuário não autenticado.");
        }

        // 1. Valida a senha atual — reutilizamos a lógica já existente de validação via login temporário
        boolean senhaAtualCorreta = keycloakAdminService.validarSenhaUsuario(usernameUsuario, senhaAtual);
        if (!senhaAtualCorreta) {
            throw new jakarta.ws.rs.WebApplicationException(
                jakarta.ws.rs.core.Response.status(401)
                    .entity(java.util.Map.of("message", "Senha atual incorreta. Verifique e tente novamente."))
                    .build()
            );
        }

        // 2. Aplica a nova senha diretamente no Keycloak via Admin Client
        keycloakAdminService.alterarSenhaUsuario(userId, novaSenha);
    }

    @Override
    @Transactional
    public gabriel.fontes.br.quarkus.Model.Cliente sincronizarUsuarioLogado() {
        String uuid = jwt.getSubject();
        if (uuid == null) {
            throw new jakarta.ws.rs.NotAuthorizedException("Usuário não autenticado.");
        }

        Cliente cliente = repository.findByIdKeycloak(uuid);
        if (cliente != null) {
            return cliente;
        }

        // Tenta também pelo e-mail caso o e-mail já esteja cadastrado para evitar duplicados
        String email = jwt.getClaim("email");
        if (email != null) {
            cliente = repository.findByEmail(email);
            if (cliente != null) {
                cliente.setIdKeycloak(uuid);
                repository.persist(cliente);
                return cliente;
            }
        }

        // Caso contrário, cria um novo Cliente (JIT Provisioning)
        Cliente novoCliente = new Cliente();
        novoCliente.setIdKeycloak(uuid);

        String nome = jwt.getClaim("name");
        if (nome == null) {
            nome = jwt.getClaim("preferred_username");
        }
        if (nome == null) {
            nome = "Usuário " + (email != null ? email : uuid);
        }

        novoCliente.setNome(nome);
        novoCliente.setEmail(email != null ? email : uuid + "@temp.com");
        novoCliente.setCpf("00000000000");
        novoCliente.setRg("0000000");
        novoCliente.setDataCadastro(LocalDateTime.now());

        repository.persist(novoCliente);
        return novoCliente;
    }
}
