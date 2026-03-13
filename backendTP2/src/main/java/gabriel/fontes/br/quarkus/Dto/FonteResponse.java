package gabriel.fontes.br.quarkus.Dto;

import gabriel.fontes.br.quarkus.Model.Fonte;
import gabriel.fontes.br.quarkus.Model.Enums.Certificacao;

public record FonteResponse(
    Long id,
    String nome,
    Integer potencia,
    double preco,
    Integer estoque,
    String marca,
    Long idMarca,
    Long idModelo,
    Certificacao certificacao
) {
    public static FonteResponse fromEntity(Fonte fonte) {
        return new FonteResponse(
            fonte.getId(),
            fonte.getNome(),
            fonte.getPotencia(),
            fonte.getPreco(),
            fonte.getEstoque(),
            fonte.getModelo().getMarca().getNome(),
            fonte.getModelo().getMarca().getId(),
            fonte.getModelo().getId(),
            fonte.getCertificacao()
        );
    }
}