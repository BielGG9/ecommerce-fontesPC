package gabriel.fontes.br.quarkus.Service;

import java.util.List;

import gabriel.fontes.br.quarkus.Dto.CartaoRequest;
import gabriel.fontes.br.quarkus.Dto.CartaoResponse;


public interface CartaoService {

    CartaoResponse create(CartaoRequest dto);
    CartaoResponse update(Long id, CartaoRequest dto);
    CartaoResponse delete(Long id);
    List<CartaoResponse> findAll();
    CartaoResponse findById(Long id);
}
