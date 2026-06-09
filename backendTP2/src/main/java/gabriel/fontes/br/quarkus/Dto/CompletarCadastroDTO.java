package gabriel.fontes.br.quarkus.Dto;

/**
 * Dados de faturamento e entrega enviados pelo frontend
 * ao endpoint PUT /clientes/completar-cadastro.
 * Todos os campos são obrigatórios para emissão da NF e entrega do pedido.
 */
public record CompletarCadastroDTO(
    String cpf,
    String cep,
    String logradouro,
    String numero,
    String telefone
) {}
