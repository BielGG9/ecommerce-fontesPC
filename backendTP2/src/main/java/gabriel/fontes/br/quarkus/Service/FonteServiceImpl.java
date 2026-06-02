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
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
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
    public List<FonteResponse> findAll(int page, int pageSize, String nome, Long idMarca, String categoria) {
        StringBuilder queryStr = new StringBuilder();
        Map<String, Object> params = new HashMap<>();

        if (nome != null && !nome.isEmpty()) {
            queryStr.append("LOWER(nome) LIKE :nome");
            params.put("nome", "%" + nome.toLowerCase() + "%");
        }

        if (idMarca != null) {
            if (queryStr.length() > 0) queryStr.append(" AND ");
            queryStr.append("modelo.marca.id = :idMarca");
            params.put("idMarca", idMarca);
        }

        if (categoria != null && !categoria.isEmpty()) {
            try {
                Certificacao cert = Certificacao.valueOf(categoria.toUpperCase());
                if (queryStr.length() > 0) queryStr.append(" AND ");
                queryStr.append("certificacao = :certificacao");
                params.put("certificacao", cert);
            } catch (IllegalArgumentException e) {
                // Ignore if invalid enum value
            }
        }

        var query = queryStr.length() > 0 
            ? repository.find(queryStr.toString(), params)
            : repository.findAll();

        return query.page(page, pageSize)
            .list()
            .stream()
            .map(FonteResponse::fromEntity)
            .collect(Collectors.toList());
    }

    @Override
    public long count(String nome, Long idMarca, String categoria) {
        StringBuilder queryStr = new StringBuilder();
        Map<String, Object> params = new HashMap<>();

        if (nome != null && !nome.isEmpty()) {
            queryStr.append("LOWER(nome) LIKE :nome");
            params.put("nome", "%" + nome.toLowerCase() + "%");
        }

        if (idMarca != null) {
            if (queryStr.length() > 0) queryStr.append(" AND ");
            queryStr.append("modelo.marca.id = :idMarca");
            params.put("idMarca", idMarca);
        }

        if (categoria != null && !categoria.isEmpty()) {
            try {
                Certificacao cert = Certificacao.valueOf(categoria.toUpperCase());
                if (queryStr.length() > 0) queryStr.append(" AND ");
                queryStr.append("certificacao = :certificacao");
                params.put("certificacao", cert);
            } catch (IllegalArgumentException e) {
                // Ignore if invalid enum value
            }
        }

        var query = queryStr.length() > 0 
            ? repository.find(queryStr.toString(), params)
            : repository.findAll();

        return query.count();
    }

    @Override
    public List<String> getCertificacoes() {
        return Arrays.stream(Certificacao.values())
                .map(Enum::name)
                .toList();
    }
    
    @Override
    public FonteResponse findById(Long id) {

        // Buscar a fonte pelo ID e lançar exceção se não encontrada
        Fonte fonte = repository.findByIdOptional(id)
            .orElseThrow(() -> new NotFoundException("Fonte com ID " + id + " não encontrada."));
        
        // Retorna o FonteResponse com o mapeamento correto garantido via fromEntity
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

        // Atualizar a lista de fornecedores
        if (dto.idFornecedores() != null) {
            java.util.List<Fornecedor> fornecedoresIds = new java.util.ArrayList<>();
            for (Long idFornecedor : dto.idFornecedores()) {
                Fornecedor fornecedor = fornecedorRepository.findByIdOptional(idFornecedor)
                        .orElseThrow(() -> new NotFoundException("Fornecedor com id " + idFornecedor + " não encontrado."));
                fornecedoresIds.add(fornecedor);
            }
            fonteExistente.setFornecedores(fornecedoresIds);
        } else {
            fonteExistente.setFornecedores(new java.util.ArrayList<>());
        }

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
