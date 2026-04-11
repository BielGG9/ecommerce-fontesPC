package gabriel.fontes.br.quarkus.Dto;

import gabriel.fontes.br.quarkus.Model.ItemPedido;

public record ItemPedidoResponse(
    Long id,
    Integer quantidade,
    Double preco,
    FonteResponse fonte
) {
    // Método para converter de entidade para DTO
    public static ItemPedidoResponse fromEntity(ItemPedido itemPedido) {
        return new ItemPedidoResponse(
            itemPedido.getId(),
            itemPedido.getQuantidade(),
            itemPedido.getPreco(),
            FonteResponse.fromEntity(itemPedido.getFonte())
        );
    }
}
