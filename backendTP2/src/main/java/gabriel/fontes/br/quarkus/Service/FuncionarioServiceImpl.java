package gabriel.fontes.br.quarkus.Service;

import gabriel.fontes.br.quarkus.Dto.FuncionarioRequest;
import gabriel.fontes.br.quarkus.Dto.FuncionarioResponse;
import gabriel.fontes.br.quarkus.Model.Departamento;
import gabriel.fontes.br.quarkus.Model.Funcionario;
import gabriel.fontes.br.quarkus.Repository.DepartamentoRepository;
import gabriel.fontes.br.quarkus.Repository.FuncionarioRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.NotFoundException;

import java.util.List;
import java.util.stream.Collectors;

@ApplicationScoped
public class FuncionarioServiceImpl implements FuncionarioService {

    @Inject
    FuncionarioRepository repository;

    @Inject
    DepartamentoRepository departamentoRepository;

    public List<FuncionarioResponse> buscarFuncionariosPorNome(String termoDeBusca) {

        // Usar o repositório para buscar funcionários cujo nome contenha o termo de busca (ignorando maiúsculas/minúsculas)
        List<Funcionario> funcionariosEncontrados = repository.findByNomeContendo(termoDeBusca);

        // Converter a lista de entidades Funcionario para uma lista de DTOs FuncionarioResponse
        return funcionariosEncontrados.stream()
                .map(FuncionarioResponse::fromEntity)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public FuncionarioResponse create(FuncionarioRequest dto) {

        // Criar um novo funcionário com os dados fornecidos
        Funcionario novoFuncionario = new Funcionario();
        novoFuncionario.setNome(dto.nome());
        novoFuncionario.setEmail(dto.email());
        novoFuncionario.setCpf(dto.cpf());
        novoFuncionario.setRg(dto.rg());
        novoFuncionario.setCargo(dto.cargo());

        // Associar o funcionário a um departamento existente
        Long departamentoId;
        try {
            departamentoId = Long.parseLong(dto.departamento());
        } catch (NumberFormatException e) {
            throw new NotFoundException("ID do departamento inválido: " + dto.departamento());
        }

        // Buscar o departamento pelo ID fornecido
        Departamento departamento = departamentoRepository.findByIdOptional(departamentoId)
                .orElseThrow(() -> new NotFoundException("Departamento com ID " + departamentoId + " não encontrado."));

        novoFuncionario.setDepartamento(departamento);

        repository.persist(novoFuncionario);
        return FuncionarioResponse.fromEntity(novoFuncionario);
    }

    @Override
    @Transactional
    public FuncionarioResponse update(Long id, FuncionarioRequest dto) {

        // Buscar o funcionário existente pelo ID
        Funcionario funcionario = repository.findByIdOptional(id)
                .orElseThrow(() -> new NotFoundException("Funcionario com id " + id + " não encontrado."));

        funcionario.setNome(dto.nome());
        funcionario.setEmail(dto.email());
        funcionario.setCpf(dto.cpf());
        funcionario.setRg(dto.rg());
        funcionario.setCargo(dto.cargo());

        // Atualizar o departamento associado
        Long departamentoId;
         try {
            departamentoId = Long.parseLong(dto.departamento());
        } catch (NumberFormatException e) {
            throw new NotFoundException("ID do departamento inválido: " + dto.departamento());
        }
        // Buscar o departamento pelo ID fornecido
        Departamento departamento = departamentoRepository.findByIdOptional(departamentoId)
                .orElseThrow(() -> new NotFoundException("Departamento com ID " + departamentoId + " não encontrado."));
        funcionario.setDepartamento(departamento);

        return FuncionarioResponse.fromEntity(funcionario);
    }

    @Override
    @Transactional
    public FuncionarioResponse delete(Long id) {

        // Verificar se o funcionário existe antes de deletar
        Funcionario funcionarioExistente = repository.findByIdOptional(id)
            .orElseThrow(() -> new NotFoundException("Funcionario com ID " + id + " não encontrado para exclusão."));

            // Excluir o funcionário e retornar a resposta
            FuncionarioResponse resposta = FuncionarioResponse.fromEntity(funcionarioExistente);
            repository.delete(funcionarioExistente);
            return resposta;
        }

    @Override
    public List<FuncionarioResponse> findAll() {

        // Buscar todos os funcionários
        return repository.listAll().stream()
                .map(FuncionarioResponse::fromEntity)
                .collect(Collectors.toList());
    }

    @Override
    public FuncionarioResponse findById(Long id) {

        // Buscar o funcionário pelo ID e lançar exceção se não encontrado
        Funcionario funcionario = repository.findByIdOptional(id)
                .orElseThrow(() -> new NotFoundException("Funcionario com id " + id + " não encontrado."));
        return FuncionarioResponse.fromEntity(funcionario);
    }
}