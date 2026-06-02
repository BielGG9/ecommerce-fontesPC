package gabriel.fontes.br.quarkus.Service;

import java.util.List;
import gabriel.fontes.br.quarkus.Dto.DesejoRequest;
import gabriel.fontes.br.quarkus.Dto.DesejoResponse;
import gabriel.fontes.br.quarkus.Dto.FonteResponse;
import gabriel.fontes.br.quarkus.Model.Cliente;
import gabriel.fontes.br.quarkus.Model.Desejo;
import gabriel.fontes.br.quarkus.Model.Fonte;
import gabriel.fontes.br.quarkus.Repository.DesejoRepository;
import gabriel.fontes.br.quarkus.Repository.FonteRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.ForbiddenException;
import jakarta.ws.rs.NotFoundException;
import jakarta.ws.rs.WebApplicationException;
import jakarta.ws.rs.core.Response;

@ApplicationScoped
public class DesejoServiceImpl implements DesejoService {

    @Inject
    DesejoRepository desejoRepository;

    @Inject
    FonteRepository fonteRepository;

    @Inject
    ClienteService clienteService;

    @Override
    public List<DesejoResponse> findMeusDesejos() {
        Cliente cliente = clienteService.sincronizarUsuarioLogado();
        return desejoRepository.findByCliente(cliente.getId())
                .stream()
                .map(d -> new DesejoResponse(d.id, FonteResponse.fromEntity(d.getFonte())))
                .toList();
    }

    @Override
    @Transactional
    public DesejoResponse create(DesejoRequest request) {
        Cliente cliente = clienteService.sincronizarUsuarioLogado();

        // verifica duplicata — retorna 409 se já existe
        desejoRepository.findByClienteAndFonte(cliente.getId(), request.idFonte())
                .ifPresent(d -> {
                    throw new WebApplicationException(
                            Response.status(Response.Status.CONFLICT)
                                    .entity("Produto já está na wishlist")
                                    .build());
                });

        Fonte fonte = fonteRepository.findById(request.idFonte());
        if (fonte == null) {
            throw new NotFoundException("Produto não encontrado");
        }

        Desejo desejo = new Desejo();
        desejo.setCliente(cliente);
        desejo.setFonte(fonte);
        desejoRepository.persist(desejo);

        return new DesejoResponse(desejo.id, FonteResponse.fromEntity(fonte));
    }

    @Override
    @Transactional
    public void delete(Long idDesejo) {
        Cliente cliente = clienteService.sincronizarUsuarioLogado();

        Desejo desejo = desejoRepository.findById(idDesejo);
        if (desejo == null) {
            throw new NotFoundException("Desejo não encontrado.");
        }

        if (!desejo.getCliente().getId().equals(cliente.getId())) {
            throw new ForbiddenException("Você não tem permissão para remover este item.");
        }

        desejoRepository.delete(desejo);
    }
}
