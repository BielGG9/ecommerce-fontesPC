package gabriel.fontes.br.quarkus.Dto;

import gabriel.fontes.br.quarkus.Model.Arquivo;

public record ArquivoResponse(
    String nomeOriginal,
    String mimeType,
    Long tamanhoBytes,
    String url
) {
    public static ArquivoResponse fromEntity(Arquivo arquivo) {
        return new ArquivoResponse(
            arquivo.getNomeOriginal(),
            arquivo.getMimeType(),
            arquivo.getTamanhoBytes(),
            "/fontes/image/download/" + arquivo.getFid()
        );
    }
}
