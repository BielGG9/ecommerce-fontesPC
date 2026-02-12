package gabriel.fontes.br.quarkus.Model;

import java.time.LocalDateTime;

import gabriel.fontes.br.quarkus.Model.Abstratc.Pagamento;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;

@Entity
@Table(name = "pix") 
public class Pix extends Pagamento{
    

    private String chavePix;
    private LocalDateTime validade;

    public Pix() {
    }

    public String getChavePix() {
        return chavePix;
    }

    public void setChavePix(String chavePix) {
        this.chavePix = chavePix;
    }

    public LocalDateTime getValidade() {
        return validade;
    }

    public void setValidade(LocalDateTime validade) {
        this.validade = validade;
    }


}
