package gabriel.fontes.br.quarkus.Model;

import java.util.List;

import gabriel.fontes.br.quarkus.Model.Abstratc.PessoaJuridica;
import jakarta.persistence.Entity;
import jakarta.persistence.ManyToMany;
import jakarta.persistence.PrimaryKeyJoinColumn;


@Entity
@PrimaryKeyJoinColumn(name = "id")
public class Fornecedor extends PessoaJuridica{


    private String razaoSocial;

    // Relação Muitos-para-Muitos com Fonte
    @ManyToMany(mappedBy = "fornecedores")
    private List<Fonte> fontes;

    public Fornecedor() {
    }

    public void setRazaoSocial(String razaoSocial) {
        this.razaoSocial = razaoSocial;
    }
    public String getRazaoSocial() {
        return razaoSocial;
    }

}
