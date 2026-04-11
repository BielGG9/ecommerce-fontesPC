package gabriel.fontes.br.quarkus.Dto;

import jakarta.validation.constraints.NotBlank;

public record DepartamentoRequest(

@NotBlank(message = "A sigla do departamento é obrigatória")
String sigla,

@NotBlank(message = "A descrição do departamento é obrigatória")
String descricao,

@NotBlank(message = "O status do departamento é obrigatório")
String statusDepartamento

) {
}
