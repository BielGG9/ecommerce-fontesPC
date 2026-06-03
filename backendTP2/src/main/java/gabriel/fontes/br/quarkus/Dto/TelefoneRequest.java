package gabriel.fontes.br.quarkus.Dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;

public record TelefoneRequest(
    
    @NotBlank(message = "O DDD não pode ser vazio")
    @Pattern(regexp = "^[0-9]{2}$", message = "O DDD deve conter exatamente 2 dígitos numéricos")
    String ddd,

    @NotBlank(message = "O número não pode ser vazio")
    @Pattern(regexp = "^[0-9]{8,9}$", message = "O número de telefone deve conter 8 ou 9 dígitos numéricos")
    String numero

) {
    
}
