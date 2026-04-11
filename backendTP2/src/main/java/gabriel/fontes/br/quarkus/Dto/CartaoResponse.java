package gabriel.fontes.br.quarkus.Dto;

import gabriel.fontes.br.quarkus.Model.Cartao;

public record CartaoResponse(
       Long id,
       String numeroCartao,
       String nomeImpresso,
       String validade,
       String cvv
) {

    public static CartaoResponse fromEntity(Cartao cartao) {
        String numero = cartao.getNumeroCartao();
        String mascara = numero != null && numero.length() >= 4
                ? "**** " + numero.substring(numero.length() - 4)
                : numero;
        return new CartaoResponse(
                cartao.getId(),
                cartao.getNumeroCartao().substring(cartao.getNumeroCartao().length() - 4),
                cartao.getNomeImpresso(),
                cartao.getValidadeCartao(),
                cartao.getCvv()
        );
    }
}