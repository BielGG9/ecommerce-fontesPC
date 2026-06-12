package gabriel.fontes.br.quarkus.Dto;

import gabriel.fontes.br.quarkus.Model.Cliente;

public record ClienteResponse(
    Long id,
    String nome,
    String email,
    String cpf,
    String rg,
    String username,
    String nomeImagem
) {

    public static ClienteResponse fromEntity(Cliente cliente) {
        return new ClienteResponse(
            cliente.getId(),
            cliente.getNome(),
            cliente.getEmail(),
            cliente.getCpf(),
            cliente.getRg(),
            null,
            cliente.getNomeImagem()
        );
    }

    public static ClienteResponse fromEntity(Cliente cliente, String username) {
        return new ClienteResponse(
            cliente.getId(),
            cliente.getNome(),
            cliente.getEmail(),
            cliente.getCpf(),
            cliente.getRg(),
            username,
            cliente.getNomeImagem()
        );
    }
}