import { Marca } from "./marca.model";
import { Modelo } from "./modelo.models";

export interface Fonte {
    id?: number;
    nome: string;
    potencia: number;
    preco: number;
    estoque: number;
    idMarca?: number;
    certificacao: string;
    marca?: Marca;
    idCertificacao?: number;
    idModelo?: number;
    modelo?: Modelo;

}

