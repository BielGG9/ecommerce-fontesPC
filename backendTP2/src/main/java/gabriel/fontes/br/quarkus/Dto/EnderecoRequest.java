package gabriel.fontes.br.quarkus.Dto;


import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;

public record EnderecoRequest( 

    @NotBlank(message = "A rua não pode ser vazia")
    String rua,

    @NotBlank(message = "O número não pode ser vazio")
    String numero,

    String complemento,

    @NotBlank(message = "O bairro não pode ser vazio")
    String bairro,

    @NotBlank(message = "A cidade não pode ser vazia")
    String cidade,

    @NotBlank(message = "O estado não pode ser vazio")
    String estado,

    @NotBlank(message = "O CEP não pode ser vazio")
    @Pattern(regexp = "^[0-9]{8}$", message = "O CEP deve conter exatamente 8 dígitos numéricos")
    String cep,

    @NotNull(message = "O ID da pessoa não pode ser nulo")
    Long idPessoa
) {

}
