import { Pessoa } from './pessoa.model';
import { Departamento } from './departamento.model';

// Herança: Funcionario "é uma" Pessoa
export interface Funcionario extends Pessoa {
    cpf: string;
    rg: string;
    cargo: string;
    dataAdmissao: string;
    idDepartamento: number;
    departamento?: Departamento | string;
    login?: string;
    salario?: number;
}