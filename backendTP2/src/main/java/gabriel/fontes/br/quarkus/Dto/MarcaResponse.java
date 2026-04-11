package gabriel.fontes.br.quarkus.Dto;

import gabriel.fontes.br.quarkus.Model.Marca;

public record MarcaResponse(
    Long id,
    String nome 

) {

public static MarcaResponse fromEntity(Marca marca) {
    return new MarcaResponse(
        marca.getId(),
        marca.getNome());
}
}
