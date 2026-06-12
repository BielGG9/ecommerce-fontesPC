import { Pessoa } from './pessoa.model';
import { Endereco } from './endereco.model'; // Certifique-se de ter este modelo criado

// Herança: Cliente "é uma" Pessoa
export interface Cliente extends Pessoa {
    cpf: string;
    rg?: string;
    nomeImagem?: string;
    login?: string;
    username?: string;
    senha?: string;
    enderecoPrincipal?: Endereco; // Relacionamento 1:1
    telefones?: any[];
    enderecos?: any[];
    cartoes?: any[];
}