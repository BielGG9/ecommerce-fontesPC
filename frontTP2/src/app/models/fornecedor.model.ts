import { Pessoa } from './pessoa.model';

// Herança: Fornecedor "é uma" Pessoa
export interface Fornecedor extends Pessoa {
    cnpj: string;
    nomeFantasia: string;
    razaoSocial: string;
    inscricaoEstadual: string;
}