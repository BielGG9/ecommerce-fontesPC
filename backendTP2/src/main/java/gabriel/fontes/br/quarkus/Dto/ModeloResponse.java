package gabriel.fontes.br.quarkus.Dto;

import gabriel.fontes.br.quarkus.Model.Modelo;

public record ModeloResponse(
    Long id,
    Long idMarca,
    String marca,
    int numeracao
) {

    public static ModeloResponse fromEntity(Modelo modelo) {
        return new ModeloResponse(
           modelo.getId(),
           modelo.getMarca() != null ? modelo.getMarca().getId() : null,
           modelo.getMarca() != null ? modelo.getMarca().getNome() : null,
           modelo.getNumeracao());
    }
}