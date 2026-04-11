import { Pessoa } from './pessoa.model';
import { endereco } from './endereco.model'; // Certifique-se de ter este modelo criado

// Herança: Cliente "é uma" Pessoa
export interface Cliente extends Pessoa {
    cpf: string;
    login: string;
    enderecoPrincipal?: endereco; // Relacionamento 1:1
}