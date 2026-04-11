package gabriel.fontes.br.quarkus.Model;

import java.time.LocalDateTime;

import gabriel.fontes.br.quarkus.Model.Abstratc.PessoaFisica;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;


@Entity
@Table(name = "cliente") 
public class Cliente extends PessoaFisica {

    private LocalDateTime dataCadastro = LocalDateTime.now();
    

    public LocalDateTime getDataCadastro() {
        return dataCadastro;
    }
    public void setDataCadastro(LocalDateTime dataCadastro) {
        this.dataCadastro = dataCadastro;
    }
}
