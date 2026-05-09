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
    Certificacao certificacao,
    java.util.List<Long> idFornecedores,
    java.util.List<ArquivoResponse> imagens
) {
    public static FonteResponse fromEntity(Fonte fonte) {
        java.util.List<Long> fornecedoresIds = (fonte.getFornecedores() != null)
            ? fonte.getFornecedores().stream().map(f -> f.getId()).collect(java.util.stream.Collectors.toList())
            : new java.util.ArrayList<>();

        java.util.List<ArquivoResponse> arquivosList = (fonte.getArquivos() != null)
            ? fonte.getArquivos().stream().map(ArquivoResponse::fromEntity).collect(java.util.stream.Collectors.toList())
            : new java.util.ArrayList<>();

        return new FonteResponse(
            fonte.getId(),
            fonte.getNome(),
            fonte.getPotencia(),
            fonte.getPreco(),
            fonte.getEstoque(),
            fonte.getModelo().getMarca().getNome(),
            fonte.getModelo().getMarca().getId(),
            fonte.getModelo().getId(),
            fonte.getCertificacao(),
            fornecedoresIds,
            arquivosList
        );
    }
}