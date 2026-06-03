import { Marca } from "./marca.model";
import { Modelo } from "./modelo.models";
import { Fornecedor } from "./fornecedor.model";
import { Certificacao } from "./certificacao.model";

/**
 * Interface alinhada com FonteResponse.java do backend.
 * Campos retornados pela API: id, nome, potencia, preco, estoque,
 * marca (string — nome da marca), idMarca, idModelo,
 * certificacao ({id, fontcert}), idFornecedores, imagens.
 */
export interface Fonte {
    fonteId(): number;
    id?: number;
    nome: string;
    potencia: number;
    preco: number;
    estoque?: number;
    /** API retorna como string simples (nome da marca) em /fontes */
    marca?: string;
    idMarca?: number;
    idModelo?: number;
    /** API retorna como objeto {id, fontcert} via @JsonFormat(OBJECT) */
    certificacao?: Certificacao;
    /** IDs dos fornecedores (retornado pela API como idFornecedores) */
    idFornecedores?: number[];
    /** Array de imagens com {url, ...} — pode vir vazio [] */
    imagens?: any[];
    // Campos usados internamente no frontend (não vêm da API /fontes)
    idCertificacao?: number;
    modelo?: Modelo;
    fornecedores?: Fornecedor[];
}