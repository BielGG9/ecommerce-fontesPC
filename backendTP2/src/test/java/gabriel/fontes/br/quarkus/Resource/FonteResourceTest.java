package gabriel.fontes.br.quarkus.Resource;

import io.quarkus.test.junit.QuarkusTest;
import io.quarkus.test.security.TestSecurity;
import io.restassured.http.ContentType;
import org.junit.jupiter.api.Test;
import gabriel.fontes.br.quarkus.Dto.FonteRequest;
import gabriel.fontes.br.quarkus.Model.Enums.Certificacao;

import static io.restassured.RestAssured.given;
import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.Matchers.greaterThanOrEqualTo;

import java.util.List; 

@QuarkusTest
@TestSecurity(user = "testUser", roles = {"ADM", "USER"})
public class FonteResourceTest {

    private static final Long EXISTING_FONTE_ID = 1L; 
    private static final Long NON_EXISTING_FONTE_ID = 999L;
    private static final Long EXISTING_MODELO_ID = 1L; 
    private static final Long EXISTING_FORNECEDOR_ID = 2L; 

    @Test
    public void testFindAllEndpoint() {
        given()
                .when().get("/fontes")
                .then()
                .statusCode(200)
                .body("size()", greaterThanOrEqualTo(0)); 
    }

    @Test
    public void testFindByIdEndpointFound() {
        given()
                .pathParam("id", EXISTING_FONTE_ID)
                .when().get("/fontes/{id}")
                .then()
                .statusCode(200) 
                .body("nome", is("RM750x")); 
    }

    @Test
    public void testCreateEndpoint() {
        
        FonteRequest requestDto = new FonteRequest(
                "Fonte Teste Create",
                550,         
                350.00,       
                10,           
                EXISTING_MODELO_ID,
                "BRONZE",
                List.of(EXISTING_FORNECEDOR_ID) // Vínculo com Fornecedor
        );

        given()
                .contentType(ContentType.JSON)
                .body(requestDto)
                .when().post("/fontes")
                .then()
                .statusCode(201)
                .body("nome", is("Fonte Teste Create"));
    }

    @Test
    public void testUpdateEndpoint() {
        FonteRequest requestDto = new FonteRequest(
                "Fonte Teste Update",
                850,          
                900.50,       
                20,           
                EXISTING_MODELO_ID,
                "GOLD",
                List.of(EXISTING_FORNECEDOR_ID) // Vínculo
        );

        given()
                .contentType(ContentType.JSON)
                .body(requestDto)
                .pathParam("id", EXISTING_FONTE_ID)
                .when().put("/fontes/{id}")
                .then()
                .statusCode(200) 
                .body("nome", is("Fonte Teste Update"));
    }

    @Test
    public void testDeleteEndpoint() {
         FonteRequest createDto = new FonteRequest("Fonte Delete", 450, 200.0, 5, EXISTING_MODELO_ID, "SILVER", null);
         var response = given()
                            .contentType(ContentType.JSON)
                            .body(createDto)
                            .when().post("/fontes")
                            .then()
                            .statusCode(201)
                            .extract().response();
         Long idToDelete = response.jsonPath().getLong("id");

        given()
                .pathParam("id", idToDelete)
                .when().delete("/fontes/{id}")
                .then()
                .statusCode(200);
    }
}