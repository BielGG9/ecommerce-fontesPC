package gabriel.fontes.br.quarkus.Dto;

import gabriel.fontes.br.quarkus.Model.Telefone;

public record TelefoneResponse(
    Long id, 
    String ddd, 
    String numero
) {

    public static TelefoneResponse fromEntity(Telefone telefone) {
        return new TelefoneResponse(
            telefone.getId(),
            telefone.getDdd(),
            telefone.getNumero()
        );
    }
}


