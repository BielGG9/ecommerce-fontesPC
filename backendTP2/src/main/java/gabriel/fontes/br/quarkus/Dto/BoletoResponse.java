package gabriel.fontes.br.quarkus.Dto;

import gabriel.fontes.br.quarkus.Model.Boleto;

public record BoletoResponse(
        Long id,
        String codigoBarras,
        Double valor
) {
    
    public static BoletoResponse fromEntity(Boleto boleto) {
        return new BoletoResponse(
                boleto.getId(),
                boleto.getCodigoBarras(),
                boleto.getValor()
        );
    }
}
