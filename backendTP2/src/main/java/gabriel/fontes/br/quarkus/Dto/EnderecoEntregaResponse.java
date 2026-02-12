package gabriel.fontes.br.quarkus.Dto;

import gabriel.fontes.br.quarkus.Model.EnderecoEntrega;

public record EnderecoEntregaResponse(
    String rua,
    String numero,
    String complemento,
    String bairro,
    String cidade,
    String estado,
    String cep
) {

    public static EnderecoEntregaResponse fromEntity(EnderecoEntrega enderecoEntrega) {
        return new EnderecoEntregaResponse(
            enderecoEntrega.getRua(),
            enderecoEntrega.getNumero(),
            enderecoEntrega.getComplemento(),
            enderecoEntrega.getBairro(),
            enderecoEntrega.getCidade(),
            enderecoEntrega.getEstado(),
            enderecoEntrega.getCep()
        );
    }
    
}
