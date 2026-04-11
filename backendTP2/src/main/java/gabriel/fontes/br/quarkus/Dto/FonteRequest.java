package gabriel.fontes.br.quarkus.Dto;

import jakarta.validation.constraints.NotNull;

import java.util.List;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Positive;

public record FonteRequest(

    @NotBlank(message = "O nome deve conter ao menos 1 caractere")
    String nome,

    @NotBlank(message = "A potência deve ser um número positivo")
    Integer potencia,


    @Positive(message = "O preço deve ser um número positivo")
    double preco,

    @Positive(message = "O estoque deve ser um número positivo")
    Integer estoque,

    @NotNull(message = "O id do modelo não pode ser nulo")
    @Positive(message = "O id do modelo deve ser um número positivo")
    Long idModelo,

    @NotBlank(message = "A certificação deve conter ao menos 1 caractere")
    String certificacao,

    List<Long> idFornecedores
    
) {}
 