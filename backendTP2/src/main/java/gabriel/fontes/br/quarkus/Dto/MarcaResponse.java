package gabriel.fontes.br.quarkus.Dto;

import gabriel.fontes.br.quarkus.Model.Marca;

public record MarcaResponse(
    Long id,
    String nome,
    java.util.List<ArquivoResponse> imagens
) {

public static MarcaResponse fromEntity(Marca marca) {
    java.util.List<ArquivoResponse> arquivosList = (marca.getArquivos() != null)
        ? marca.getArquivos().stream().map(ArquivoResponse::fromEntity).collect(java.util.stream.Collectors.toList())
        : new java.util.ArrayList<>();

    return new MarcaResponse(
        marca.getId(),
        marca.getNome(),
        arquivosList
    );
}
}
