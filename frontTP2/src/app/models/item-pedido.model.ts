import { Fonte } from './fonte.model';

export interface ItemPedido {
    id?: number;
    quantidade: number;
    precoUnitario: number;
    fonte?: Fonte; // Associação simples
}