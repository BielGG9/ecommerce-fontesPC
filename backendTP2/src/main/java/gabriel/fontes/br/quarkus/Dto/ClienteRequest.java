package gabriel.fontes.br.quarkus.Dto;



import jakarta.validation.constraints.NotBlank;

public record ClienteRequest(
    @NotBlank(message = "O nome não pode ser vazio")
    String nome,

    @NotBlank(message = "O email não pode ser vazio")
    String email,

    @NotBlank(message = "O CPF não pode ser vazio")
    String cpf,

    @NotBlank(message = "O RG não pode ser vazio")
    String rg,
    
    @NotBlank(message = "A senha é obrigatória")
    String senha
    
) {
}