package gabriel.fontes.br.quarkus.Model;

import gabriel.fontes.br.quarkus.Model.Abstratc.DefaultEntity;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;

@Entity
@Table(name = "marca")
public class Marca extends DefaultEntity {
    
   
    private String nome;

    @jakarta.persistence.OneToMany(fetch = jakarta.persistence.FetchType.EAGER, orphanRemoval = true, cascade = { jakarta.persistence.CascadeType.PERSIST, jakarta.persistence.CascadeType.MERGE })
    @jakarta.persistence.JoinTable(name = "marca_arquivo", joinColumns = @jakarta.persistence.JoinColumn(name = "marca_id"), inverseJoinColumns = @jakarta.persistence.JoinColumn(name = "arquivo_id", unique = true))
    private java.util.List<Arquivo> arquivos = new java.util.ArrayList<>();

    public Marca() {
    }
    public Marca(String nome) {
        this.nome = nome;
    }
    public String getNome() {
        return nome;
    }
    public void setNome(String nome) {
        this.nome = nome;
    }

    public java.util.List<Arquivo> getArquivos() {
        return arquivos;
    }

    public void setArquivos(java.util.List<Arquivo> arquivos) {
        this.arquivos = arquivos;
    }

    public void addArquivo(Arquivo arquivo) {
        if (arquivo != null) {
            this.arquivos.add(arquivo);
        }
    }

    public void removeArquivo(Arquivo arquivo) {
        if (arquivo != null) {
            this.arquivos.remove(arquivo);
        }
    }
}
