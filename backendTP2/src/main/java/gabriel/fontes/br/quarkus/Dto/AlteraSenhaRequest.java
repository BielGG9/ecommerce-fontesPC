package gabriel.fontes.br.quarkus.Dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

/**
 * DTO para a requisição de alteração de senha do usuário logado.
 * Recebe a senha atual (para autenticar a operação) e a nova senha desejada.
 */
public record AlteraSenhaRequest(

    @NotBlank(message = "A senha atual é obrigatória.")
    String senhaAtual,

    @NotBlank(message = "A nova senha é obrigatória.")
    @Size(min = 6, message = "A nova senha deve ter no mínimo 6 caracteres.")
    String novaSenha

) {}
