package gabriel.fontes.br.quarkus.Model.Enums;


import com.fasterxml.jackson.annotation.JsonFormat;

import jakarta.ws.rs.NotAuthorizedException;

@JsonFormat(shape = JsonFormat.Shape.OBJECT)
public enum TipoPagamento {
    
    PIX(1l, "pix"),
    CARTAO_CREDITO(2l, "cartao_credito"),
    BOLETO(3l, "boleto");

    public final long ID;
    public final String LABEL;
    TipoPagamento(Long id, String label) {
        this.ID = id;
        this.LABEL = label;
    }

    public static TipoPagamento valueOf(Long id) {
        if (id == null) {
            return null;
        }

        for (TipoPagamento tipoPagamento : TipoPagamento.values()) {
        if (tipoPagamento.ID == (id))  {
        return tipoPagamento;
    
        }      
    }
        throw new NotAuthorizedException("Id invalido! " + id);
}  
}