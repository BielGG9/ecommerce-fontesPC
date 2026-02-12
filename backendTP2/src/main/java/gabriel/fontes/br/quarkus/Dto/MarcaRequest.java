package gabriel.fontes.br.quarkus.Dto;

import jakarta.validation.constraints.NotBlank;

public record MarcaRequest (

    @NotBlank(message = "O nome deve conter ao menos 1 caractere")
    String nome
) {}