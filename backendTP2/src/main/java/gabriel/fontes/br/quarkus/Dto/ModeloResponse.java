package gabriel.fontes.br.quarkus.Dto;

import gabriel.fontes.br.quarkus.Model.Modelo;

public record ModeloResponse(
    Long id,
    String marca,
    int numeracao
) {

    public static ModeloResponse fromEntity(Modelo modelo) {
        return new ModeloResponse(
           modelo.getId(),
           modelo.getMarca().getNome(),
           modelo.getNumeracao());
    }
}