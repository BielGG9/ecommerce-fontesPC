package gabriel.fontes.br.quarkus.Model;

import java.time.LocalDateTime;

import gabriel.fontes.br.quarkus.Model.Abstratc.Pagamento;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;

@Entity
@Table(name = "boleto")
public class Boleto extends Pagamento{
    
    private String codigoBarras;
    private LocalDateTime dataVencimento;

    public Boleto() {
    }

    public String getCodigoBarras() {
        return codigoBarras;
    }

    public void setCodigoBarras(String codigoBarras) {
        this.codigoBarras = codigoBarras;
    }

    public LocalDateTime getDataVencimento() {
        return dataVencimento;
    }

    public void setDataVencimento(LocalDateTime dataVencimento) {
        this.dataVencimento = dataVencimento;
    }

}