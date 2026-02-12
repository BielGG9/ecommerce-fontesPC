package gabriel.fontes.br.quarkus.Dto;

import java.util.List;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;

public record PedidoRequest(
    
    @NotBlank(message = "O nome do cliente é obrigatório")
    String nomeCliente,


    @NotNull(message = "O endereço de entrega é obrigatório")
    Long idEnderecoEntrega,

    @NotEmpty(message = "O pedido deve ter pelo menos um item")
    @Valid // Valida cada item dentro da lista
    List<ItemPedidoRequest> itensPedido,
   
    @NotBlank(message = "O tipo de pagamento deve ser informado (boleto, pix ou cartao)")
    String pagamento,

    Long idCartao,

    CartaoRequest novoCartao
) {    
}