package gabriel.fontes.br.quarkus.Dto;

public record DashboardResponse(
    Long totalFontes,
    Long totalMarcas,
    Double vendasDiarias,
    Long quantidadeVendasDiarias
) {}
