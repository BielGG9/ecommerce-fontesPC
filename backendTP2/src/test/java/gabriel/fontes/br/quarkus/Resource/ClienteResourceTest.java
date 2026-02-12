package gabriel.fontes.br.quarkus.Resource; 

import io.quarkus.test.junit.QuarkusTest;
import io.quarkus.test.security.TestSecurity;
import io.restassured.http.ContentType;
import org.junit.jupiter.api.Test;
import gabriel.fontes.br.quarkus.Dto.ClienteRequest;

import static io.restassured.RestAssured.given;
import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.Matchers.greaterThan;

@QuarkusTest
@TestSecurity(user = "test-user-id", roles = {"ADM", "USER"})
public class ClienteResourceTest {

        private static final Long EXISTING_CLIENTE_ID = 1L; 
        private static final Long NON_EXISTING_CLIENTE_ID = 999L;

        @Test
        public void testFindAllEndpoint() {
                given()
                                .when().get("/clientes")
                                .then()
                                .statusCode(200)
                                .body("size()", greaterThan(0));
        }

        @Test
        public void testFindByIdEndpointFound() {
                given()
                                .pathParam("id", EXISTING_CLIENTE_ID)
                                .when().get("/clientes/{id}")
                                .then()
                                .statusCode(200)
                                .body("id", is(EXISTING_CLIENTE_ID.intValue()))
                                .body("nome", is("biel")); 
        }

        @Test
        public void testCreateEndpoint() {
                ClienteRequest requestDto = new ClienteRequest(
                                "Novo Cliente Teste",
                                "novo.teste@unico.com", 
                                "111.222.333-44", 
                                "1234567 SSP/SP"
                );

                given()
                                .contentType(ContentType.JSON)
                                .body(requestDto)
                                .when().post("/clientes")
                                .then()
                                .statusCode(201)
                                .body("nome", is("Novo Cliente Teste"));
        }

        @Test
        public void testUpdateEndpoint() {
                ClienteRequest requestDto = new ClienteRequest(
                                "Cliente Atualizado",
                                "atualizado@email.com",
                                "555.666.777-88", 
                                "9876543 SSP/RJ"
                );

                given()
                                .contentType(ContentType.JSON)
                                .body(requestDto)
                                .pathParam("id", EXISTING_CLIENTE_ID) 
                                .when().put("/clientes/{id}")
                                .then()
                                .statusCode(200) 
                                .body("nome", is("Cliente Atualizado"));
        }

        @Test
        public void testDeleteEndpoint() {
                ClienteRequest createDto = new ClienteRequest(
                                "Cliente Para Deletar", 
                                "delete@temp.com", 
                                "000.000.000-00", 
                                "0000000 SSP/SP"
                );
                 
                long idToDelete = given()
                                .contentType(ContentType.JSON)
                                .body(createDto)
                                .when().post("/clientes")
                                .then()
                                .statusCode(201)
                                .extract().jsonPath().getLong("id");

                given()
                                .pathParam("id", idToDelete)
                                .when().delete("/clientes/{id}")
                                .then()
                                .statusCode(204); 
        }
}
