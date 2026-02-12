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
     * - Pega o ID do Keycloak do token
     * - Impede duplicações
     * - Persiste a entidade
     */
    @Override
    @Transactional
    public ClienteResponse create(ClienteRequest dto) {

        // ID do usuário autenticado
        String idUsuarioKeycloak = jwt.getSubject();

        // Valor temporário caso token não esteja presente
        if (idUsuarioKeycloak == null) {
            idUsuarioKeycloak = "ID_TEMPO_DE_TESTE";
        }

        // Impede que o mesmo usuário se cadastre duas vezes
        if (repository.findByIdKeycloak(idUsuarioKeycloak) != null) {
            throw new ForbiddenException("Usuário já cadastrado como cliente.");
        }

        // Criação da entidade Cliente
        Cliente novoCliente = new Cliente();
        novoCliente.setNome(dto.nome());
        novoCliente.setEmail(dto.email());
        novoCliente.setCpf(dto.cpf());
        novoCliente.setRg(dto.rg());
        novoCliente.setDataCadastro(LocalDateTime.now());
        novoCliente.setIdKeycloak(idUsuarioKeycloak);

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
}
