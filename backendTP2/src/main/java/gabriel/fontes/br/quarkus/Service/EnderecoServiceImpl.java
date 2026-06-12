package gabriel.fontes.br.quarkus.Service;

import gabriel.fontes.br.quarkus.Dto.EnderecoRequest;
import gabriel.fontes.br.quarkus.Dto.EnderecoResponse;
import gabriel.fontes.br.quarkus.Model.Endereco;
import gabriel.fontes.br.quarkus.Model.Abstratc.Pessoa;
import gabriel.fontes.br.quarkus.Repository.EnderecoRepository;
import gabriel.fontes.br.quarkus.Repository.PessoaRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.BadRequestException;
import jakarta.ws.rs.NotFoundException;

import org.eclipse.microprofile.jwt.JsonWebToken;
import gabriel.fontes.br.quarkus.Model.Cliente;
import gabriel.fontes.br.quarkus.Repository.ClienteRepository;

import java.util.List;
import java.util.stream.Collectors;

@ApplicationScoped
public class EnderecoServiceImpl implements EnderecoService {

    @Inject
    EnderecoRepository repository;

    @Inject
    PessoaRepository pessoaRepository;

    @Inject
    JsonWebToken jwt;

    @Inject
    ClienteRepository clienteRepository;

    // Implementação de um método de busca personalizada
    public List<EnderecoResponse> buscarEnderecosPorRua(String parametroDeBusca) {
        List<Endereco> enderecosEncontrados = repository.findByNomeContendo(parametroDeBusca); // Ajustar query se necessário

        return enderecosEncontrados.stream()
                .map(EnderecoResponse::fromEntity)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public EnderecoResponse create(EnderecoRequest dto) {
        System.out.println("DEBUG EnderecoServiceImpl.create: dto.salvo() = " + dto.salvo());
        // Criar um novo endereço com os dados fornecidos
        Endereco novoEndereco = new Endereco();
        novoEndereco.setRua(dto.rua());
        novoEndereco.setNumero(dto.numero());
        novoEndereco.setComplemento(dto.complemento());
        novoEndereco.setBairro(dto.bairro());
        novoEndereco.setCidade(dto.cidade());
        novoEndereco.setEstado(dto.estado());
        novoEndereco.setCep(dto.cep());
        novoEndereco.setSalvo(dto.salvo() != null ? dto.salvo() : true);
        System.out.println("DEBUG EnderecoServiceImpl.create: novoEndereco.getSalvo() = " + novoEndereco.getSalvo());

        // Associar o endereço a uma pessoa existente
        if (dto.idPessoa() != null) {
        Pessoa pessoa = pessoaRepository.findById(dto.idPessoa());
        if (pessoa == null) {
            throw new NotFoundException("Pessoa não encontrada");
        }
        novoEndereco.setPessoa(pessoa); 
    } else {
        throw new BadRequestException("O endereço precisa pertencer a uma pessoa.");
    }

        repository.persist(novoEndereco);
        return EnderecoResponse.fromEntity(novoEndereco);
    }

    @Override
    @Transactional
    public EnderecoResponse update(Long id, EnderecoRequest dto) {
        // Buscar o endereço existente pelo ID
        Endereco endereco = repository.findByIdOptional(id)
                .orElseThrow(() -> new NotFoundException("Endereco com id " + id + " não encontrado."));

        endereco.setRua(dto.rua());
        endereco.setNumero(dto.numero());
        endereco.setComplemento(dto.complemento());
        endereco.setBairro(dto.bairro());
        endereco.setCidade(dto.cidade());
        endereco.setEstado(dto.estado());
        endereco.setCep(dto.cep());
        if (dto.salvo() != null) {
            endereco.setSalvo(dto.salvo());
        }

        return EnderecoResponse.fromEntity(endereco);
    }

    @Override
    @Transactional
    public EnderecoResponse delete(Long id) {
        // Verificar se o endereço existe antes de deletar
        Endereco enderecoExistente = repository.findByIdOptional(id)
            .orElseThrow(() -> new NotFoundException("Endereco com ID " + id + " não encontrado para exclusão."));

        EnderecoResponse resposta = EnderecoResponse.fromEntity(enderecoExistente);
        repository.delete(enderecoExistente);
        return resposta;
    }

    @Override
    public List<EnderecoResponse> findAll() {
        // Converter a lista de entidades Endereco para uma lista de DTOs EnderecoResponse
        return repository.listAll().stream()
                .map(EnderecoResponse::fromEntity)
                .collect(Collectors.toList());
    }

    @Override
    public EnderecoResponse findById(Long id) {
        // Buscar o endereço pelo ID e lançar exceção se não encontrado
        Endereco endereco = repository.findByIdOptional(id)
                .orElseThrow(() -> new NotFoundException("Endereco com id " + id + " não encontrado."));
        return EnderecoResponse.fromEntity(endereco);
    }

    @Override
    public List<EnderecoResponse> findMeusEnderecos() {
        String idUsuarioKeycloak = jwt.getSubject();
        if (idUsuarioKeycloak == null) {
            throw new jakarta.ws.rs.NotAuthorizedException("Usuário não autenticado.");
        }
        Cliente cliente = clienteRepository.findByIdKeycloak(idUsuarioKeycloak);
        if (cliente == null) {
            throw new NotFoundException("Cliente não encontrado.");
        }
        return repository.find("pessoa.id = ?1 and (salvo is null or salvo = true)", cliente.getId()).stream()
                .map(EnderecoResponse::fromEntity)
                .collect(Collectors.toList());
    }
}