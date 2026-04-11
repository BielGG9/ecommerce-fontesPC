package gabriel.fontes.br.quarkus.Model.Jpa;

import gabriel.fontes.br.quarkus.Model.Enums.Certificacao;
import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

@Converter(autoApply = true)
public class CertificacaoConverter implements AttributeConverter<Certificacao, Long> {

    @Override
    public Long convertToDatabaseColumn(Certificacao certificacao) {
        
        return (certificacao == null) ? null : (long) certificacao.getId();
    }

    @Override
    public Certificacao convertToEntityAttribute(Long id) {
        if (id == null) {
            return null;
        }
        return Certificacao.getById(id.intValue());
    }
}