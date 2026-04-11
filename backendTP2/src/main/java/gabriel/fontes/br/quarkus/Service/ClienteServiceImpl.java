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
    public ClienteResponse getMeuPerfil() {
        String idUsuarioKeycloak = jwt.getSubject();

        // Busca cliente atrelado ao ID do Keycloak
        Cliente cliente = repository.findByIdKeycloak(idUsuarioKeycloak);

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
        // O IdKeycloak fica nulo por enquanto. Se modificar o keycloakAdminService no futuro para extrair a String do header Location, pode preencher!
        keycloakAdminService.criarUsuario(dto.nome(), dto.email(), dto.senha());

        // 3. Ordem Correta: SEGUNDO instanciar e popular
        Cliente novoCliente = new Cliente();
        novoCliente.setNome(dto.nome());
        novoCliente.setEmail(dto.email());
        novoCliente.setCpf(dto.cpf());
        novoCliente.setRg(dto.rg());
        novoCliente.setDataCadastro(LocalDateTime.now());
        novoCliente.setIdKeycloak(null); // idKeycloak nulo temporariamente para parar o Erro 500

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
}
