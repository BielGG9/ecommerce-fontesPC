package gabriel.fontes.br.quarkus.Resource;

import io.quarkus.test.junit.QuarkusTest;
import io.quarkus.test.security.TestSecurity;
import io.restassured.http.ContentType;
import org.junit.jupiter.api.Test;

import gabriel.fontes.br.quarkus.Dto.ModeloRequest;

import static io.restassured.RestAssured.given;
import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.Matchers.greaterThan;

@QuarkusTest
@TestSecurity(user = "testUser", roles = {"ADM", "USER"})
public class ModeloResourceTest {

    private static final Long EXISTING_MODELO_ID = 1L;
    private static final Long NON_EXISTING_MODELO_ID = 999L;
    
    private static final Long MARCA_ID_PARA_TESTE = 2L; 
    private static final String NOME_MARCA_PARA_TESTE = "Seasonic";

    @Test
    public void testFindAllEndpoint() {
        given()
                .when().get("/modelos")
                .then()
                .statusCode(200)
                .body("size()", greaterThan(0));
    }

    @Test
    public void testFindByIdEndpointFound() {
        given()
                .pathParam("id", EXISTING_MODELO_ID)
                .when().get("/modelos/{id}")
                .then()
                .statusCode(200)
                .body("numeracao", is(750));
    }

    @Test
    public void testCreateEndpoint() {
        ModeloRequest requestDto = new ModeloRequest(850, MARCA_ID_PARA_TESTE);

        given()
                .contentType(ContentType.JSON)
                .body(requestDto)
                .when().post("/modelos")
                .then()
                .statusCode(201)
                .body("numeracao", is(850))
                .body("marca", is(NOME_MARCA_PARA_TESTE)); 
    }

    @Test
    public void testUpdateEndpoint() {
        ModeloRequest requestDto = new ModeloRequest(900, MARCA_ID_PARA_TESTE);

        given()
                .contentType(ContentType.JSON)
                .body(requestDto)
                .pathParam("id", EXISTING_MODELO_ID)
                .when().put("/modelos/{id}")
                .then()
                .statusCode(200)
                .body("numeracao", is(900)); 
    }

    @Test
    public void testDeleteEndpoint() {

         ModeloRequest createDto = new ModeloRequest(1200, MARCA_ID_PARA_TESTE);
         var response = given()
                            .contentType(ContentType.JSON)
                            .body(createDto)
                            .when().post("/modelos")
                            .then()
                            .statusCode(201)
                            .extract().response();
         Long idToDelete = response.jsonPath().getLong("id");

        given()
                .pathParam("id", idToDelete)
                .when().delete("/modelos/{id}")
                .then()
                .statusCode(200);
    }
}