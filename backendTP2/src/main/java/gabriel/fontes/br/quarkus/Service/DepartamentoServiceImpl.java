package gabriel.fontes.br.quarkus.Service;

import gabriel.fontes.br.quarkus.Dto.DepartamentoRequest;
import gabriel.fontes.br.quarkus.Dto.DepartamentoResponse;
import gabriel.fontes.br.quarkus.Model.Departamento;
import gabriel.fontes.br.quarkus.Repository.DepartamentoRepository;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.NotFoundException;

import java.util.List;
import java.util.stream.Collectors;

@ApplicationScoped 
public class DepartamentoServiceImpl implements DepartamentoService {

    @Inject 
    DepartamentoRepository repository;

    @Inject
    gabriel.fontes.br.quarkus.Repository.FuncionarioRepository funcionarioRepository;

    @Override
    @Transactional 
    public DepartamentoResponse create(DepartamentoRequest dto) {
 
        // Criar um novo departamento com os dados fornecidos
        Departamento novoDepartamento = new Departamento();

        novoDepartamento.setSigla(dto.sigla());
        novoDepartamento.setDescricao(dto.descricao());
        repository.persist(novoDepartamento);

        return DepartamentoResponse.fromEntity(novoDepartamento);
    }

    
    @Override
    public List<DepartamentoResponse> findAll(int page, int pageSize, String nome) {
        var query = (nome != null && !nome.isEmpty())
        ? repository.find("descricao LIKE ?1", "%" + nome + "%")
        : repository.findAll();
        
        return query.page(page, pageSize)
        .list()
        .stream()
        .map(DepartamentoResponse::fromEntity)
        .collect(Collectors.toList());
    }

    @Override
    public long count(String search) {
        var query = (search != null && !search.isEmpty())
        ? repository.find("descricao LIKE ?1", "%" + search + "%")
        : repository.findAll();
        
        return query.count();
    }

    
    @Override
    public DepartamentoResponse findById(Long id) {
    
        // Buscar o departamento pelo ID e lançar exceção se não encontrado
        Departamento departamento = repository.findByIdOptional(id)
            .orElseThrow(() -> new NotFoundException("Departamento com ID " + id + " não encontrado."));

        return DepartamentoResponse.fromEntity(departamento);
    }

   
    @Override
    @Transactional
    public DepartamentoResponse update(Long id, DepartamentoRequest dto) {

        // Buscar o departamento existente pelo ID
        Departamento departamentoExistente = repository.findByIdOptional(id)
            .orElseThrow(() -> new NotFoundException("Departamento com ID " + id + " não encontrado para atualização."));

        departamentoExistente.setSigla(dto.sigla());
        departamentoExistente.setDescricao(dto.descricao());


        return DepartamentoResponse.fromEntity(departamentoExistente);
    }

    @Override
    @Transactional
    public DepartamentoResponse delete(Long id) {
        // Verificar se o departamento existe antes de deletar
        Departamento departamentoExistente = repository.findByIdOptional(id)
            .orElseThrow(() -> new NotFoundException("Departamento com ID " + id + " não encontrado para exclusão."));

        // Impedir erro 500 (ConstraintViolationException)
        long vinculados = funcionarioRepository.count("departamento.id", id);
        if (vinculados > 0) {
            throw new jakarta.ws.rs.WebApplicationException(
                "Não é possível excluir este Departamento, pois há " + vinculados + " funcionário(s) alocado(s) a ele.",
                jakarta.ws.rs.core.Response.Status.BAD_REQUEST
            );
        }

        DepartamentoResponse resposta = DepartamentoResponse.fromEntity(departamentoExistente);
        repository.delete(departamentoExistente);
        return resposta;
    }
    }