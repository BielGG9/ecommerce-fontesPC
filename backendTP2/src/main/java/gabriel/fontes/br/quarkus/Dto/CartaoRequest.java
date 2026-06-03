package gabriel.fontes.br.quarkus.Dto;


import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;


public record CartaoRequest(

        @NotBlank(message = "O número do cartão é obrigatório")
        @Pattern(regexp = "^[0-9]{16}$", message = "O número do cartão deve conter exatamente 16 dígitos numéricos")
        String numeroCartao,

        @NotBlank(message = "O nome impresso é obrigatório")
        String nomeImpresso,

        @NotBlank(message = "A validade do cartão é obrigatória")
        String validadeCartao,

        @NotBlank(message = "O CVV é obrigatório")
        @Pattern(regexp = "^[0-9]{3,4}$", message = "O CVV deve conter 3 ou 4 dígitos numéricos")
        String cvv

) {

 }

