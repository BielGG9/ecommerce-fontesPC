package gabriel.fontes.br.quarkus.Service;

import gabriel.fontes.br.quarkus.Dto.FonteRequest;
import gabriel.fontes.br.quarkus.Dto.FonteResponse;
import gabriel.fontes.br.quarkus.Model.Fonte;
import gabriel.fontes.br.quarkus.Model.Fornecedor;
import gabriel.fontes.br.quarkus.Model.Modelo;
import gabriel.fontes.br.quarkus.Model.Enums.Certificacao;
import gabriel.fontes.br.quarkus.Repository.FonteRepository;
import gabriel.fontes.br.quarkus.Repository.FornecedorRepository;
import gabriel.fontes.br.quarkus.Repository.ModeloRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.NotFoundException;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@ApplicationScoped 
public class FonteServiceImpl implements FonteService {

    @Inject 
    FonteRepository repository;

    @Inject 
    ModeloRepository modeloRepository;

    @Inject
    FornecedorRepository fornecedorRepository;

    @Override
    @Transactional 
    public FonteResponse create(FonteRequest dto) {

        // Criar uma nova fonte com os dados fornecidos
        Fonte novaFonte = new Fonte();

        // Associar fornecedores à fonte, se fornecidos no DTO
        if (dto.idFornecedores() != null && !dto.idFornecedores().isEmpty()) {
            List<Fornecedor> fornecedoresIds = new ArrayList<>();
        
            // Buscar e adicionar cada fornecedor pelo ID
            for (Long idFornecedor : dto.idFornecedores()) {
                Fornecedor fornecedor = fornecedorRepository.findByIdOptional(idFornecedor)
                        .orElseThrow(() -> new NotFoundException("Fornecedor com id " + idFornecedor + " não encontrado."));
                fornecedoresIds.add(fornecedor);
            }
            
            // Definir a lista de fornecedores na nova fonte
            novaFonte.setFornecedores(fornecedoresIds);
        }

        // Definir os outros atributos da fonte  
        novaFonte.setNome(dto.nome());
        novaFonte.setPotencia(dto.potencia());
        novaFonte.setPreco(dto.preco());
        novaFonte.setEstoque(dto.estoque());
        
        // Associar a fonte a um modelo existente
        Modelo modelo = modeloRepository.findByIdOptional(dto.idModelo())
                .orElseThrow(() -> new NotFoundException("Modelo com id " + dto.idModelo() + " não encontrado."));
        novaFonte.setModelo(modelo);
        
        // Definir a certificação a partir do valor do DTO
        novaFonte.setCertificacao(Certificacao.valueOf(dto.certificacao().toUpperCase()));

        repository.persist(novaFonte);

        return FonteResponse.fromEntity(novaFonte);
    }

    
    @Override
    public List<FonteResponse> findAll() {
        // Converter a lista de entidades Fonte para uma lista de DTOs FonteResponse
        return repository.listAll().stream()
                .map(FonteResponse::fromEntity)
                .collect(Collectors.toList());
    }

    
    @Override
    public FonteResponse findById(Long id) {

        // Buscar a fonte pelo ID e lançar exceção se não encontrada
        Fonte fonte = repository.findByIdOptional(id)
            .orElseThrow(() -> new NotFoundException("Fonte com ID " + id + " não encontrada."));
        
        return FonteResponse.fromEntity(fonte);
    }

   
    @Override
    @Transactional
    public FonteResponse update(Long id, FonteRequest dto) {
        
        // Buscar a fonte existente pelo ID
        Fonte fonteExistente = repository.findByIdOptional(id)
            .orElseThrow(() -> new NotFoundException("Fonte com ID " + id + " não encontrada para atualização."));

       
        fonteExistente.setNome(dto.nome());
        fonteExistente.setPotencia(dto.potencia());
        fonteExistente.setPreco(dto.preco());
        fonteExistente.setEstoque(dto.estoque());

        // Atualizar o modelo associado
        Modelo modelo = modeloRepository.findByIdOptional(dto.idModelo())
                .orElseThrow(() -> new NotFoundException("Modelo com id " + dto.idModelo() + " não encontrado."));
        fonteExistente.setModelo(modelo);

        // Atualizar a certificação a partir do valor do DTO
        fonteExistente.setCertificacao(Certificacao.valueOf(dto.certificacao().toUpperCase()));


        return FonteResponse.fromEntity(fonteExistente);
    }

    @Override
    @Transactional
    public FonteResponse delete(Long id) {
        // Verificar se a fonte existe antes de deletar
        Fonte fonteExistente = repository.findByIdOptional(id)
            .orElseThrow(() -> new NotFoundException("Fonte com ID " + id + " não encontrada para exclusão."));

            // Excluir a fonte e retornar a resposta
            FonteResponse resposta = FonteResponse.fromEntity(fonteExistente);
            repository.delete(fonteExistente);
            return resposta;
        }
    }
