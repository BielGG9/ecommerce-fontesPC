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

        if (idUsuarioKeycloak == null) {
            throw new jakarta.ws.rs.NotAuthorizedException("Usuário não autenticado.");
        }

        // Busca a representação do usuário direto do Keycloak (tempo real)
        org.keycloak.representations.idm.UserRepresentation userRep = keycloakAdminService.obterUsuario(idUsuarioKeycloak);

        // Verifica se o usuário existe e está ativo/habilitado no Keycloak
        if (userRep == null || !userRep.isEnabled()) {
            throw new io.quarkus.security.ForbiddenException("Usuário desativado ou não encontrado no Keycloak.");
        }

        // Busca cliente atrelado ao ID do Keycloak
        Cliente cliente = repository.findByIdKeycloak(idUsuarioKeycloak);

        // Fallback: se não achar pelo ID, tenta pelo e-mail
        if (cliente == null && emailUsuario != null) {
            cliente = repository.findByEmail(emailUsuario);
            
            if (cliente == null) {
                // Sincronização automática: O usuário existe no Keycloak mas sumiu do Postgres (ex: drop-and-create)
                Cliente novoCliente = new Cliente();
                
                String nome = null;
                String firstName = userRep.getFirstName();
                String lastName = userRep.getLastName();
                if (firstName != null && !firstName.trim().isEmpty()) {
                    nome = firstName.trim();
                    if (lastName != null && !lastName.trim().isEmpty()) {
                        nome += " " + lastName.trim();
                    }
                } else {
                    nome = userRep.getUsername();
                }
                
                novoCliente.setNome(nome != null ? nome : "Usuário " + emailUsuario);
                novoCliente.setEmail(emailUsuario);

                // Tenta extrair CPF e RG das claims do Keycloak
                String cpfClaim = null;
                String rgClaim = null;
                java.util.Map<String, java.util.List<String>> attributes = userRep.getAttributes();
                if (attributes != null) {
                    java.util.List<String> cpfList = attributes.get("cpf");
                    if (cpfList != null && !cpfList.isEmpty()) {
                        cpfClaim = cpfList.get(0);
                    }
                    java.util.List<String> rgList = attributes.get("rg");
                    if (rgList != null && !rgList.isEmpty()) {
                        rgClaim = rgList.get(0);
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

        // Sincroniza dados atualizados do Keycloak
        sincronizarDadosToken(cliente, userRep);

        // Retorna com o username atualizado do Keycloak (fallback token se null)
        String username = (userRep != null) ? userRep.getUsername() : jwt.getClaim("preferred_username");
        return ClienteResponse.fromEntity(cliente, username);
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

        // Propaga as alterações de Nome, E-mail, CPF e RG para o Keycloak
        if (cliente.getIdKeycloak() != null) {
            keycloakAdminService.atualizarUsuario(cliente.getIdKeycloak(), dto.nome(), dto.email(), dto.cpf(), dto.rg());
        }

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

        // Busca a representação do usuário direto do Keycloak (tempo real)
        org.keycloak.representations.idm.UserRepresentation userRep = keycloakAdminService.obterUsuario(uuid);

        // Verifica se o usuário ainda está ativo/habilitado no Keycloak
        if (userRep == null || !userRep.isEnabled()) {
            throw new io.quarkus.security.ForbiddenException("Usuário desativado ou não encontrado no Keycloak.");
        }

        Cliente cliente = repository.findByIdKeycloak(uuid);
        if (cliente != null) {
            sincronizarDadosToken(cliente, userRep);
            return cliente;
        }

        // Tenta também pelo e-mail caso o e-mail já esteja cadastrado para evitar duplicados
        String email = userRep.getEmail();
        if (email != null) {
            cliente = repository.findByEmail(email);
            if (cliente != null) {
                cliente.setIdKeycloak(uuid);
                sincronizarDadosToken(cliente, userRep);
                repository.persist(cliente);
                return cliente;
            }
        }

        // Caso contrário, cria um novo Cliente (JIT Provisioning)
        Cliente novoCliente = new Cliente();
        novoCliente.setIdKeycloak(uuid);

        String nome = null;
        String firstName = userRep.getFirstName();
        String lastName = userRep.getLastName();
        if (firstName != null && !firstName.trim().isEmpty()) {
            nome = firstName.trim();
            if (lastName != null && !lastName.trim().isEmpty()) {
                nome += " " + lastName.trim();
            }
        } else {
            nome = userRep.getUsername();
        }
        if (nome == null) {
            nome = "Usuário " + (email != null ? email : uuid);
        }

        novoCliente.setNome(nome);
        novoCliente.setEmail(email != null ? email : uuid + "@temp.com");

        // CPF e RG das attributes
        String cpfClaim = null;
        String rgClaim = null;
        java.util.Map<String, java.util.List<String>> attributes = userRep.getAttributes();
        if (attributes != null) {
            java.util.List<String> cpfList = attributes.get("cpf");
            if (cpfList != null && !cpfList.isEmpty()) {
                cpfClaim = cpfList.get(0);
            }
            java.util.List<String> rgList = attributes.get("rg");
            if (rgList != null && !rgList.isEmpty()) {
                rgClaim = rgList.get(0);
            }
        }

        novoCliente.setCpf(cpfClaim != null ? cpfClaim : "00000000000");
        novoCliente.setRg(rgClaim != null ? rgClaim : "0000000");
        novoCliente.setDataCadastro(LocalDateTime.now());

        repository.persist(novoCliente);
        return novoCliente;
    }

    private void sincronizarDadosToken(Cliente cliente, org.keycloak.representations.idm.UserRepresentation userRep) {
        if (cliente == null) return;
        
        boolean modificado = false;
        String nomeToken = null;
        String emailUsuario = null;
        String cpfClaim = null;
        String rgClaim = null;

        if (userRep != null) {
            // Sincronizar pelo Keycloak Admin API em tempo real
            String firstName = userRep.getFirstName();
            String lastName = userRep.getLastName();
            if (firstName != null && !firstName.trim().isEmpty()) {
                nomeToken = firstName.trim();
                if (lastName != null && !lastName.trim().isEmpty()) {
                    nomeToken += " " + lastName.trim();
                }
            } else {
                nomeToken = userRep.getUsername();
            }

            emailUsuario = userRep.getEmail();

            java.util.Map<String, java.util.List<String>> attributes = userRep.getAttributes();
            if (attributes != null) {
                java.util.List<String> cpfList = attributes.get("cpf");
                if (cpfList != null && !cpfList.isEmpty()) {
                    cpfClaim = cpfList.get(0);
                }
                java.util.List<String> rgList = attributes.get("rg");
                if (rgList != null && !rgList.isEmpty()) {
                    rgClaim = rgList.get(0);
                }
            }
        } else {
            // Fallback: Sincronizar pelas claims do token JWT
            nomeToken = jwt.getClaim("name");
            if (nomeToken == null) {
                nomeToken = jwt.getClaim("given_name");
                if (nomeToken != null && jwt.getClaim("family_name") != null) {
                    nomeToken += " " + jwt.getClaim("family_name");
                }
            }
            if (nomeToken == null) {
                nomeToken = jwt.getClaim("preferred_username");
            }
            
            emailUsuario = jwt.getClaim("email");

            cpfClaim = jwt.getClaim("cpf");
            rgClaim = jwt.getClaim("rg");
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
        }

        // Aplicar as atualizações
        if (nomeToken != null && !nomeToken.equals(cliente.getNome())) {
            cliente.setNome(nomeToken);
            modificado = true;
        }
        
        if (emailUsuario != null && !emailUsuario.equals(cliente.getEmail())) {
            cliente.setEmail(emailUsuario);
            modificado = true;
        }
        
        if (cpfClaim != null && !cpfClaim.equals(cliente.getCpf()) && !cpfClaim.equals("00000000000")) {
            cliente.setCpf(cpfClaim);
            modificado = true;
        }
        if (rgClaim != null && !rgClaim.equals(cliente.getRg()) && !rgClaim.equals("0000000")) {
            cliente.setRg(rgClaim);
            modificado = true;
        }

        if (modificado) {
            repository.persist(cliente);
        }
    }
}
