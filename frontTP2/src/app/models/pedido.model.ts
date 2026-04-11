import { ItemPedido } from './item-pedido.model';
import { Cliente } from './cliente.model';

export interface Pedido {
    id?: number;
    dataHora: Date;
    valorTotal: number;
    cliente?: Cliente;
    itens: ItemPedido[]; // Composição: Um pedido é composto obrigatoriamente por itens! Se o pedido some, os itens somem.
}