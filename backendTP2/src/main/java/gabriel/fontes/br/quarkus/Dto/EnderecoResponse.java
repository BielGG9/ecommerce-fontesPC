package gabriel.fontes.br.quarkus.Dto;

import gabriel.fontes.br.quarkus.Model.Endereco;

public record EnderecoResponse(
    Long id,
    String rua,
    String numero,
    String complemento,
    String bairro,
    String cidade,
    String estado,
    String cep
) {
    public static EnderecoResponse fromEntity(Endereco endereco) {
        return new EnderecoResponse(
            endereco.getId(),
            endereco.getRua(),
            endereco.getNumero(),
            endereco.getComplemento(),
            endereco.getBairro(),
            endereco.getCidade(),
            endereco.getEstado(),
            endereco.getCep()
        );
    }
}