package gabriel.fontes.br.quarkus.Model.Jpa;

import gabriel.fontes.br.quarkus.Model.Enums.Perfil;
import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

@Converter(autoApply = true)
public class PerfilConverter implements AttributeConverter<Perfil, Long>{

    @Override
    public Long convertToDatabaseColumn(Perfil perfil) {
        return (perfil == null) ? null : perfil.ID;
    }

    @Override
    public Perfil convertToEntityAttribute(Long id) {
        return Perfil.valueOf(id);
    }
    
}