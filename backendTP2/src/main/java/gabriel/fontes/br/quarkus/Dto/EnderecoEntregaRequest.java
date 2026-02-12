package gabriel.fontes.br.quarkus.Dto;

import jakarta.validation.constraints.NotBlank;

public record EnderecoEntregaRequest (

    
    @NotBlank(message = "A rua não pode ser vazia")
    String rua,

    @NotBlank(message = "O número não pode ser vazio")
    String numero,

    @NotBlank(message = "O complemento não pode ser vazio")
    String complemento,

    @NotBlank(message = "O bairro não pode ser vazio")
    String bairro,

    @NotBlank(message = "A cidade não pode ser vazia")
    String cidade,

    @NotBlank(message = "O estado não pode ser vazio")
    String estado,

    @NotBlank(message = "O CEP não pode ser vazio")
    String cep
)

{}
