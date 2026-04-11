package gabriel.fontes.br.quarkus.Config;

import jakarta.ws.rs.core.Application;
import org.eclipse.microprofile.openapi.annotations.OpenAPIDefinition;
import org.eclipse.microprofile.openapi.annotations.enums.SecuritySchemeType;
import org.eclipse.microprofile.openapi.annotations.info.Info;
import org.eclipse.microprofile.openapi.annotations.security.OAuthFlow;
import org.eclipse.microprofile.openapi.annotations.security.OAuthFlows;
import org.eclipse.microprofile.openapi.annotations.security.SecurityRequirement;
import org.eclipse.microprofile.openapi.annotations.security.SecurityScheme;

@OpenAPIDefinition(
    info = @Info(
        title = "API Fontes TP1",
        version = "1.0.0",
        description = "API com autenticação via Keycloak"
    ),

    // Isso aplica a segurança (o cadeado) em toda a API globalmente
    security = @SecurityRequirement(name = "Keycloak")
)
@SecurityScheme(
    securitySchemeName = "Keycloak",
    type = SecuritySchemeType.OAUTH2, 
    description = "Autenticação via Keycloak",
    flows = @OAuthFlows(
        authorizationCode = @OAuthFlow(

            // Ajuste estas URLs se seu realm não for 'meu-realm'
            authorizationUrl = "http://localhost:8080/realms/meu-realm/protocol/openid-connect/auth",
            tokenUrl = "http://localhost:8080/realms/meu-realm/protocol/openid-connect/token"
        )
    )
)

public class SwaggerConfig extends Application {
}