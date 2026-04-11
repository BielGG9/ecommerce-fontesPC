package gabriel.fontes.br.quarkus.Dto;

import java.time.LocalDateTime;
import java.util.List;

import gabriel.fontes.br.quarkus.Model.Pedido;

public record PedidoResponse(
    Long id,
    String nomeCliente,
    Double total,
    LocalDateTime data,
    EnderecoEntregaResponse enderecoEntrega,
    List<ItemPedidoResponse> itensPedido,
    Object pagamento,
    String status
) {

    public static PedidoResponse fromEntity(Pedido pedido) {

        EnderecoEntregaResponse enderecoRes = null;
        if (pedido.getEnderecoEntrega() != null) {
            enderecoRes = EnderecoEntregaResponse.fromEntity(pedido.getEnderecoEntrega());
        }

        Object pagamentoRes = null;
        if (pedido.getPagamento() != null) {
            pagamentoRes = PagamentoResponse.fromEntity(pedido.getPagamento());
        }

        return new PedidoResponse(
            pedido.getId(),
            pedido.getNomeClienteSnapshot(),
            pedido.getTotal(),
            pedido.getData(),
            enderecoRes,
            pedido.getItens().stream().map(ItemPedidoResponse::fromEntity).toList(),
            pagamentoRes,
            pedido.getStatus().getStts()
        );
    }
}
