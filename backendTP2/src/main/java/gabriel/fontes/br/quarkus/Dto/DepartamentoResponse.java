package gabriel.fontes.br.quarkus.Dto;



public record DepartamentoResponse(
    Long id,
    String sigla,
    String descricao
) {

    public static DepartamentoResponse fromEntity(gabriel.fontes.br.quarkus.Model.Departamento departamento) {
        return new DepartamentoResponse(
            departamento.getId(),
            departamento.getSigla(),
            departamento.getDescricao()
        );
    }
}
