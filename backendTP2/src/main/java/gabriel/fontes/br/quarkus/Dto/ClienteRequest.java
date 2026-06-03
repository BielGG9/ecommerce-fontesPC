package gabriel.fontes.br.quarkus.Dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;

public record ClienteRequest(
    @NotBlank(message = "O nome não pode ser vazio")
    String nome,

    @NotBlank(message = "O nome de usuário não pode ser vazio")
    String username,

    @NotBlank(message = "O email não pode ser vazio")
    String email,

    @NotBlank(message = "O CPF não pode ser vazio")
    @Pattern(regexp = "^[0-9]{11}$", message = "O CPF deve conter exatamente 11 dígitos numéricos")
    String cpf,

    @NotBlank(message = "O RG não pode ser vazio")
    @Pattern(regexp = "^[0-9]{7,15}$", message = "O RG deve conter de 7 a 15 dígitos numéricos")
    String rg,
    
    @NotBlank(message = "A senha é obrigatória")
    String senha
    
) {
}