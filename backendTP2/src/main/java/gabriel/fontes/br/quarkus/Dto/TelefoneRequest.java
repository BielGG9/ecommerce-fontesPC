package gabriel.fontes.br.quarkus.Dto;

import jakarta.validation.constraints.NotBlank;

public record TelefoneRequest(
    
    @NotBlank(message = "O DDD não pode ser vazio")
    String ddd,

    @NotBlank(message = "O número não pode ser vazio")
    String numero

) {
    
}
