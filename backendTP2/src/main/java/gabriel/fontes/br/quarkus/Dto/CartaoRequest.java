package gabriel.fontes.br.quarkus.Dto;


import jakarta.validation.constraints.NotBlank;


public record CartaoRequest(

        @NotBlank(message = "O número do cartão é obrigatório")
        String numeroCartao,

        @NotBlank(message = "O nome impresso é obrigatório")
        String nomeImpresso,

        @NotBlank(message = "A validade do cartão é obrigatória")
        String validadeCartao,

        @NotBlank(message = "O CVV é obrigatório")
        String cvv

) {

 }

