package gabriel.fontes.br.quarkus.Service;

import gabriel.fontes.br.quarkus.Dto.TelefoneRequest;
import gabriel.fontes.br.quarkus.Dto.TelefoneResponse;
import gabriel.fontes.br.quarkus.Model.Telefone;
import gabriel.fontes.br.quarkus.Repository.TelefoneRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.NotFoundException;

import java.util.List;
import java.util.stream.Collectors;

@ApplicationScoped
public class TelefoneServiceImpl implements TelefoneService{

    @Inject
    TelefoneRepository repository;

    public List<TelefoneResponse> buscarTelefonesPorNumero(String parametroDeBusca) {
    
    // Usar o repositório para buscar telefones cujo número contenha o parâmetro de busca
    List<Telefone> telefonesEncontrados = repository.FindByTelefone(parametroDeBusca);

    // Converter a lista de entidades Telefone para uma lista de DTOs TelefoneResponse
    return telefonesEncontrados.stream()
               .map(TelefoneResponse::fromEntity)
               .collect(Collectors.toList());
}
    
    @Override
    @Transactional
    public TelefoneResponse create(TelefoneRequest dto) {

        // Criar um novo telefone com os dados fornecidos
        Telefone novoTelefone = new Telefone();
        novoTelefone.setNumero(dto.numero());
        novoTelefone.setDdd(dto.ddd());
        repository.persist(novoTelefone);
        return TelefoneResponse.fromEntity(novoTelefone);
    }

    @Override
    @Transactional
    public TelefoneResponse update(Long id, TelefoneRequest dto) {

        // Buscar o telefone existente pelo ID
        Telefone telefone = repository.findByIdOptional(id)
                .orElseThrow(() -> new NotFoundException("Telefone com id " + id + " não encontrado."));
        telefone.setNumero(dto.numero());
        telefone.setDdd(dto.ddd());
        return TelefoneResponse.fromEntity(telefone);
    }

    @Override
    @Transactional
    public TelefoneResponse delete(Long id) {

        // Verificar se o telefone existe antes de deletar
        Telefone telefoneExistente = repository.findByIdOptional(id)
            .orElseThrow(() -> new NotFoundException("Telefone com ID " + id + " não encontrado para exclusão."));

        // Excluir o telefone e retornar a resposta
        TelefoneResponse resposta = TelefoneResponse.fromEntity(telefoneExistente);
        repository.delete(telefoneExistente);
        return resposta;
    }

    @Override
    public List<TelefoneResponse> findAll() {

        // Buscar todos os telefones
        return repository.listAll().stream()
                .map(TelefoneResponse::fromEntity)
                .collect(Collectors.toList());
    }

    @Override
    public TelefoneResponse findById(Long id) {

        // Buscar o telefone pelo ID e lançar exceção se não encontrado
        Telefone telefone = repository.findByIdOptional(id)
                .orElseThrow(() -> new NotFoundException("Telefone com id " + id + " não encontrado."));
        return TelefoneResponse.fromEntity(telefone);
    }
}