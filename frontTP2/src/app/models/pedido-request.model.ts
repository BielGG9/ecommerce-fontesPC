import { ItemPedidoRequest } from "./item-pedido-request.model";
import { CartaoRequest } from "./cartao-request.model";

export interface PedidoRequest {
    nomeCliente: string;
    idEnderecoEntrega: number;
    itensPedido: ItemPedidoRequest[];
    pagamento: string; // 'boleto', 'pix', 'cartao'
    idCartao?: number;
    novoCartao?: CartaoRequest;
}
