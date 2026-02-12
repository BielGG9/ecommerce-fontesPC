package gabriel.fontes.br.quarkus.Service;

import gabriel.fontes.br.quarkus.Dto.ModeloRequest;
import gabriel.fontes.br.quarkus.Dto.ModeloResponse;
import gabriel.fontes.br.quarkus.Model.Marca;
import gabriel.fontes.br.quarkus.Model.Modelo;
import gabriel.fontes.br.quarkus.Repository.MarcaRepository;
import gabriel.fontes.br.quarkus.Repository.ModeloRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.NotFoundException;

import java.util.List;
import java.util.stream.Collectors;

@ApplicationScoped
public class ModeloServiceImpl implements ModeloService {

    @Inject
    ModeloRepository repository;

    @Inject
    MarcaRepository marcaRepository;

    public List<ModeloResponse> buscarMarcasPorNome(String termoDeBusca) {

        // Usar o repositório para buscar modelos cujo nome contenha o termo de busca (ignorando maiúsculas/minúsculas)
        List<Modelo> modelosEncontrados = repository.findByNomeContendo(termoDeBusca);
    
        // Converter a lista de entidades Modelo para uma lista de DTOs ModeloResponse
        return modelosEncontrados.stream()
               .map(ModeloResponse::fromEntity)
               .collect(Collectors.toList());
    }
    

    @Override
    @Transactional
    public ModeloResponse create(ModeloRequest dto) {

        // Criar um novo modelo com os dados fornecidos
        Modelo novoModelo = new Modelo();
        novoModelo.setNumeracao(dto.numeracao());

        // Associar o modelo a uma marca existente
        Marca marca = marcaRepository.findByIdOptional(dto.idMarca())
                .orElseThrow(() -> new NotFoundException("Marca com id " + dto.idMarca() + " não encontrada."));
        novoModelo.setMarca(marca);

        
        repository.persist(novoModelo);
        return ModeloResponse.fromEntity(novoModelo);
    }

    @Override
    @Transactional
    public ModeloResponse update(Long id, ModeloRequest dto) {

        //  Buscar o modelo existente pelo ID
        Modelo modelo = repository.findByIdOptional(id)
                .orElseThrow(() -> new NotFoundException("Modelo com id " + id + " não encontrada."));
        
        modelo.setNumeracao(dto.numeracao());

        // Atualizar a associação do modelo com a marca
        Marca marca = marcaRepository.findByIdOptional(dto.idMarca())
                .orElseThrow(() -> new NotFoundException("Marca com id " + dto.idMarca() + " não encontrada."));
        modelo.setMarca(marca);

        return ModeloResponse.fromEntity(modelo);
    }

    @Override
    @Transactional
    public ModeloResponse delete(Long id) {

        // Verificar se o modelo existe antes de deletar
        Modelo modeloexistente = repository.findByIdOptional(id)
            .orElseThrow(() -> new NotFoundException("Modelo com ID " + id + " não encontrada para exclusão."));

            // Excluir o modelo e retornar a resposta
            ModeloResponse resposta = ModeloResponse.fromEntity(modeloexistente);
            repository.delete(modeloexistente);
            return resposta;
        }

    @Override
    public List<ModeloResponse> findAll() {

        // Buscar todos os modelos
        return repository.listAll().stream()
                .map(ModeloResponse::fromEntity)
                .collect(Collectors.toList());
    }

    @Override
    public ModeloResponse findById(Long id) {

        // Buscar o modelo pelo ID e lançar exceção se não encontrada
        Modelo modelo = repository.findByIdOptional(id)
                .orElseThrow(() -> new NotFoundException("Modelo com id " + id + " não encontrada."));
        return ModeloResponse.fromEntity(modelo);
    }
}