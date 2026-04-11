package gabriel.fontes.br.quarkus.Dto;

import java.time.LocalDateTime;

import gabriel.fontes.br.quarkus.Model.Pix;

public record PixResponse(
        Long id,
        String chavePix,
        LocalDateTime validade,
        Double valor

) {
    public static PixResponse fromEntity(Pix pix) {
        return new PixResponse(
                pix.getId(),
                pix.getChavePix(),
                pix.getValidade(),
                pix.getValor()
        );
    }
}
