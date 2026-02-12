package gabriel.fontes.br.quarkus.Dto;

import gabriel.fontes.br.quarkus.Model.Boleto;
import gabriel.fontes.br.quarkus.Model.Cartao;
import gabriel.fontes.br.quarkus.Model.Pix;
import gabriel.fontes.br.quarkus.Model.Abstratc.Pagamento;

public record PagamentoResponse(Object pagamento) {

    public static PagamentoResponse fromEntity(Pagamento pagamento) {

        if (pagamento instanceof Pix pix) {
            return new PagamentoResponse(PixResponse.fromEntity(pix));
        }

        if (pagamento instanceof Cartao c) {
            return new PagamentoResponse(CartaoResponse.fromEntity(c));
        }

        if (pagamento instanceof Boleto b) {
            return new PagamentoResponse(BoletoResponse.fromEntity(b));
        }

        return null;
    }
}
