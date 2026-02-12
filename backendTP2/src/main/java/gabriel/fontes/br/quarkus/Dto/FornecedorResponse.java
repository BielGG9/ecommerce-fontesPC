package gabriel.fontes.br.quarkus.Dto;

import gabriel.fontes.br.quarkus.Model.Fornecedor;

public record FornecedorResponse (
    Long id, 
    String nome,
    String email,
    String razaoSocial,
    String cnpj,
    String inscricaoEstadual
) {
    
    public static FornecedorResponse fromEntity(Fornecedor fornecedor) {
        return new FornecedorResponse(
           fornecedor.getId(),
           fornecedor.getNome(),
            fornecedor.getEmail(),
            fornecedor.getRazaoSocial(),
            fornecedor.getCnpj(),
            fornecedor.getInscricaoEstadual()   
        );
    }
}
