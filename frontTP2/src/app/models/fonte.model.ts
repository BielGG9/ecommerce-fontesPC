import { Marca } from "./marca.model";
import { Modelo } from "./modelo.models";
import { Fornecedor } from "./fornecedor.model";
import { Certificacao } from "./certificacao.model";

export interface Fonte {
    id?: number;
    nome: string;
    potencia: number;
    preco: number;
    estoque?: number;
    idMarca?: number;
    certificacao?: Certificacao;
    marca?: Marca;
    idCertificacao?: number;
    idModelo?: number;
    modelo?: Modelo;
    fornecedores?: Fornecedor[]; // Relacionamento Muitos-para-Muitos (N:N)
}