package gabriel.fontes.br.quarkus.Dto;

import jakarta.validation.constraints.NotBlank;

public record FornecedorRequest( 
    
    @NotBlank(message = "O nome do fornecedor é obrigatório.")
    String nome,

    @NotBlank(message = "O email do fornecedor é obrigatório.")
    String email,

    @NotBlank(message = "A razão social do fornecedor é obrigatória.")
    String razaoSocial,

    @NotBlank(message = "O CNPJ do fornecedor é obrigatório.")
    String cnpj,

    @NotBlank(message = "A inscrição estadual do fornecedor é obrigatória.")
    String inscricaoEstadual
    
) {}
