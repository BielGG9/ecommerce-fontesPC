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
            fonte.getCertificacao()
        );
    }
}