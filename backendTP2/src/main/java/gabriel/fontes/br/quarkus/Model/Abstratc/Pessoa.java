package gabriel.fontes.br.quarkus.Model.Abstratc; // Pode mover para gabriel.fontes.br.quarkus.Model

import jakarta.persistence.Entity;
import jakarta.persistence.Inheritance;
import jakarta.persistence.InheritanceType;
import jakarta.persistence.OneToMany;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;

import java.util.List;
import gabriel.fontes.br.quarkus.Model.Endereco;
import gabriel.fontes.br.quarkus.Model.Telefone;


@Entity
@Inheritance(strategy = InheritanceType.JOINED) // Define a estratégia de herança
public abstract class Pessoa extends DefaultEntity { // Continua abstrata

    private String nome;
    private String email;

    @OneToMany(mappedBy = "pessoa", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Endereco> enderecos;

    @OneToMany(mappedBy = "pessoa", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Telefone> telefones;

    @Column(unique = true)
    private String idKeycloak;


    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public List<Endereco> getEnderecos() { return enderecos; }
    public void setEnderecos(List<Endereco> enderecos) { this.enderecos = enderecos; }
    public List<Telefone> getTelefones() { return telefones; }
    public void setTelefones(List<Telefone> telefones) { this.telefones = telefones; }
    public String getIdKeycloak() { return idKeycloak; }
    public void setIdKeycloak(String idKeycloak) { this.idKeycloak = idKeycloak; }
}