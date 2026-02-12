package gabriel.fontes.br.quarkus.Model.Enums;


import com.fasterxml.jackson.annotation.JsonFormat;

import jakarta.ws.rs.NotAuthorizedException;

@JsonFormat(shape = JsonFormat.Shape.OBJECT)
public enum Perfil {
    
    ADM(1l, "Administrador"),
    USER(2l, "Usuário");

    public final long ID;
    public final String LABEL;
    Perfil(Long id, String label) {
        this.ID = id;
        this.LABEL = label;
    }

    public static Perfil valueOf(Long id) {
        if (id == null) {
            return null;
        }

        for (Perfil perfil : Perfil.values()) {
        if (perfil.ID == (id))  {
        return perfil;
    
        }      
    }
        throw new NotAuthorizedException("Id invalido! " + id);
}  
}