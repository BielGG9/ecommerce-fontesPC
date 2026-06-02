package gabriel.fontes.br.quarkus.Dto;

public record CupomResponse(
    String codigo,
    Double porcentagem,
    Boolean valido
) {}
