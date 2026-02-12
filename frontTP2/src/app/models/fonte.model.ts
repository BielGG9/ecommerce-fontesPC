export interface Fonte {
    id: number;
    nome: string;
    potencia: number;
    preco: number;
    estoque: number;
    marca: string;
    certificacao: string; // Enums usually come as strings in JSON unless configured otherwise
}
