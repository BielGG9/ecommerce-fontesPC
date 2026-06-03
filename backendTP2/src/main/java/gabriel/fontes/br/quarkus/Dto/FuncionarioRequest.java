package gabriel.fontes.br.quarkus.Dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;

public record FuncionarioRequest(

    @NotBlank(message = "O nome do funcionário é obrigatório")
    String nome,

    @NotBlank(message = "O email do funcionário é obrigatório")
    String email,

    @NotBlank(message = "O CPF do funcionário é obrigatório")
    @Pattern(regexp = "^[0-9]{11}$", message = "O CPF deve conter exatamente 11 dígitos numéricos")
    String cpf,

    @NotBlank(message = "O RG do funcionário é obrigatório")
    @Pattern(regexp = "^[0-9]{7,15}$", message = "O RG deve conter de 7 a 15 dígitos numéricos")
    String rg,
    
    @NotBlank(message = "O cargo do funcionário é obrigatório")
    String cargo,

    @NotNull(message = "O departamento do funcionário é obrigatório.")
    Long idDepartamento,

    @NotNull(message = "A data de admissão é obrigatória")
    java.time.LocalDate dataAdmissao
) {}
