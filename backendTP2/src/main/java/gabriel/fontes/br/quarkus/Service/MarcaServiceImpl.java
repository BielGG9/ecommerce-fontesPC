package gabriel.fontes.br.quarkus.Service;

import gabriel.fontes.br.quarkus.Dto.MarcaRequest;
import gabriel.fontes.br.quarkus.Dto.MarcaResponse;
import gabriel.fontes.br.quarkus.Model.Marca;
import gabriel.fontes.br.quarkus.Repository.MarcaRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.NotFoundException;

import java.util.List;
import java.util.stream.Collectors;

@ApplicationScoped
public class MarcaServiceImpl implements MarcaService {

    @Inject
    MarcaRepository repository;

    public List<MarcaResponse> buscarMarcasPorNome(String termoDeBusca) {
    
    // Usar o repositório para buscar marcas cujo nome contenha o termo de busca (ignorando maiúsculas/minúsculas)
    List<Marca> marcasEncontradas = repository.findByNomeContendo(termoDeBusca);
    
    // Converter a lista de entidades Marca para uma lista de DTOs MarcaResponse
    return marcasEncontradas.stream()
               .map(MarcaResponse::fromEntity)
               .collect(Collectors.toList());
}
    

    @Override
    @Transactional
    public MarcaResponse create(MarcaRequest dto) {
        // Criar uma nova marca com os dados fornecidos
        Marca novaMarca = new Marca();
        novaMarca.setNome(dto.nome());
        repository.persist(novaMarca);
        return MarcaResponse.fromEntity(novaMarca);
    }

    @Override
    @Transactional
    public MarcaResponse update(Long id, MarcaRequest dto) {

        // Buscar a marca existente pelo ID
        Marca marca = repository.findByIdOptional(id)
                .orElseThrow(() -> new NotFoundException("Marca com id " + id + " não encontrada."));
        marca.setNome(dto.nome());
        return MarcaResponse.fromEntity(marca);
    }

    @Override
    @Transactional
    public MarcaResponse delete(Long id) {

        // Verificar se a marca existe antes de deletar
        Marca marcaExistente = repository.findByIdOptional(id)
            .orElseThrow(() -> new NotFoundException("Marca com ID " + id + " não encontrada para exclusão."));

            // Excluir a marca e retornar a resposta
            MarcaResponse resposta = MarcaResponse.fromEntity(marcaExistente);
            repository.delete(marcaExistente);
            return resposta;
        }

    @Override
    public List<MarcaResponse> findAll() {
        // Buscar todas as marcas
        return repository.listAll().stream()
                .map(MarcaResponse::fromEntity)
                .collect(Collectors.toList());
    }

    @Override
    public MarcaResponse findById(Long id) {
        
        // Buscar a marca pelo ID e lançar exceção se não encontrada
        Marca marca = repository.findByIdOptional(id)
                .orElseThrow(() -> new NotFoundException("Marca com id " + id + " não encontrada."));
        return MarcaResponse.fromEntity(marca);
    }
}