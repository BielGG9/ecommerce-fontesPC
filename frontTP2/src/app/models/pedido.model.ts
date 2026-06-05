import { ItemPedido } from './item-pedido.model';
import { Cliente } from './cliente.model';

export interface Pedido {
    id?: number;
    dataHora: Date;
    valorTotal: number;
    cliente?: Cliente;
    nomeCliente?: string;
    cpfCliente?: string;
    formaPagamento?: string;
    itens: ItemPedido[]; // Composição: Um pedido é composto obrigatoriamente por itens! Se o pedido some, os itens somem.
    enderecoEntrega?: {
        rua: string;
        numero: string;
        complemento?: string;
        bairro: string;
        cidade: string;
        estado: string;
        cep: string;
    };
}