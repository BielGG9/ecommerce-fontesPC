import { Pessoa } from './pessoa.model';
import { Departamento } from './departamento.model';

// Herança: Funcionario "é uma" Pessoa
export interface Funcionario extends Pessoa {
    cpf: string;
    login: string;
    salario: number;
    idDepartamento?: number;
    departamento?: Departamento; // Agregação (1:N)
}