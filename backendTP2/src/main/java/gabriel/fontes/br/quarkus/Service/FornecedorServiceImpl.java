package gabriel.fontes.br.quarkus.Service;

import gabriel.fontes.br.quarkus.Dto.FornecedorRequest;
import gabriel.fontes.br.quarkus.Dto.FornecedorResponse;
import gabriel.fontes.br.quarkus.Model.Fornecedor;
import gabriel.fontes.br.quarkus.Repository.FornecedorRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.NotFoundException;

import java.util.List;
import java.util.stream.Collectors;

@ApplicationScoped
public class FornecedorServiceImpl implements FornecedorService {

    @Inject
    FornecedorRepository repository;

    public List<FornecedorResponse> buscarFornecedoresPorNome(String termoDeBusca) {

        // Usar o repositório para buscar fornecedores cujo nome contenha o termo de busca (ignorando maiúsculas/minúsculas)
        List<Fornecedor> fornecedoresEncontrados = repository.findByNomeContendo(termoDeBusca);

        return fornecedoresEncontrados.stream()
                .map(FornecedorResponse::fromEntity)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public FornecedorResponse create(FornecedorRequest dto) {

        // Criar um novo fornecedor com os dados fornecidos
        Fornecedor novoFornecedor = new Fornecedor();
        novoFornecedor.setNome(dto.nome());
        novoFornecedor.setEmail(dto.email());
        novoFornecedor.setRazaoSocial(dto.razaoSocial());
        novoFornecedor.setCnpj(dto.cnpj());
        novoFornecedor.setInscricaoEstadual(dto.inscricaoEstadual());

        repository.persist(novoFornecedor);
        return FornecedorResponse.fromEntity(novoFornecedor);
    }

    @Override
    @Transactional
    public FornecedorResponse update(Long id, FornecedorRequest dto) {
        
        // Buscar o fornecedor existente pelo ID
        Fornecedor fornecedor = repository.findByIdOptional(id)
                .orElseThrow(() -> new NotFoundException("Fornecedor com id " + id + " não encontrado."));

        fornecedor.setNome(dto.nome());
        fornecedor.setEmail(dto.email());
        fornecedor.setRazaoSocial(dto.razaoSocial());
        fornecedor.setCnpj(dto.cnpj());
        fornecedor.setInscricaoEstadual(dto.inscricaoEstadual());

        return FornecedorResponse.fromEntity(fornecedor);
    }

    @Inject
    gabriel.fontes.br.quarkus.Repository.FonteRepository fonteRepository;

    @Override
    @Transactional
    public FornecedorResponse delete(Long id) {
        // Verificar se o fornecedor existe antes de deletar
        Fornecedor fornecedorExistente = repository.findByIdOptional(id)
            .orElseThrow(() -> new NotFoundException("Fornecedor com ID " + id + " não encontrado para exclusão."));

        long fontesVinculadas = fonteRepository.find("?1 member of fornecedores", fornecedorExistente).count();

        if (fontesVinculadas > 0) {
            throw new jakarta.ws.rs.WebApplicationException(
                "Não é possível excluir este Fornecedor, pois há " + fontesVinculadas + " fonte(s) vinculada(s) a ele.",
                jakarta.ws.rs.core.Response.Status.BAD_REQUEST
            );
        }

        FornecedorResponse resposta = FornecedorResponse.fromEntity(fornecedorExistente);
        repository.delete(fornecedorExistente);
        return resposta;
    }

    @Override
    public List<FornecedorResponse> findAll(int page, int pageSize, String nome) {
        var query = (nome != null && !nome.isEmpty())
        ? repository.find("nome LIKE ?1", "%" + nome + "%")
        : repository.findAll();
        
        return query.page(page, pageSize)
        .list()
        .stream()
        .map(FornecedorResponse::fromEntity)
        .collect(Collectors.toList());
    }

    @Override
    public long count(String search) {
        var query = (search != null && !search.isEmpty())
        ? repository.find("nome LIKE ?1", "%" + search + "%")
        : repository.findAll();
        
        return query.count();
    }

    @Override
    public FornecedorResponse findById(Long id) {

        // Buscar o fornecedor pelo ID e lançar exceção se não encontrado
        Fornecedor fornecedor = repository.findByIdOptional(id)
                .orElseThrow(() -> new NotFoundException("Fornecedor com id " + id + " não encontrado."));
        return FornecedorResponse.fromEntity(fornecedor);
    }
}