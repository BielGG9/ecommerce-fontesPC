package gabriel.fontes.br.quarkus.Dto;

public record FuncionarioResponse(
    Long id,
    String email,
    String nome,
    String cpf,
    String rg,
    String cargo,
    String departamento
) {

    public static FuncionarioResponse fromEntity(gabriel.fontes.br.quarkus.Model.Funcionario funcionario) {
        String nomeDepartamento = funcionario.getDepartamento() != null ? funcionario.getDepartamento().getDescricao() : "Sem Departamento";

        return new FuncionarioResponse(
            funcionario.getId(),
            funcionario.getEmail(),
            funcionario.getNome(),
            funcionario.getCpf(),
            funcionario.getRg(),
            funcionario.getCargo(),
            nomeDepartamento
        );
    }
}
