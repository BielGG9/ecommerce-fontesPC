package gabriel.fontes.br.quarkus.Resource;

import io.quarkus.test.junit.QuarkusTest;
import io.quarkus.test.security.TestSecurity;
import io.restassured.http.ContentType;
import org.junit.jupiter.api.Test; 

import gabriel.fontes.br.quarkus.Dto.TelefoneRequest;

import static io.restassured.RestAssured.given;
import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.Matchers.greaterThan;

@QuarkusTest 
@TestSecurity(user = "testUser", roles = {"ADM", "USER"})
public class TelefoneResourceTest {

    private static final Long EXISTING_TELEFONE_ID = 1L;
    
     @Test
    public void testFindAllEndpoint() {
        given()
                .when().get("/telefones")
                .then()
                .statusCode(200)
                .body("size()", greaterThan(0)); 
    }

     @Test
    public void testFindByIdEndpointFound() {
        given()
                .pathParam("id", EXISTING_TELEFONE_ID)
                .when().get("/telefones/{id}")
                .then()
                .statusCode(200)
                .body("ddd", is("63")) 
                .body("numero", is("98765-4321")); 
    }

    @Test
    public void testCreateEndpoint() {
        TelefoneRequest requestDto = new TelefoneRequest("71", "98888-7777");

        given()
                .contentType(ContentType.JSON)
                .body(requestDto)
                .when().post("/telefones")
                .then()
                .statusCode(201)
                .body("ddd", is("71"));
    }

    @Test
    public void testUpdateEndpoint() {
         TelefoneRequest requestDto = new TelefoneRequest("61", "3333-4444");

        given()
                .contentType(ContentType.JSON)
                .body(requestDto)
                .pathParam("id", EXISTING_TELEFONE_ID)
                .when().put("/telefones/{id}")
                .then()
                .statusCode(200)
                .body("numero", is("3333-4444"));
    }

    @Test
    public void testDeleteEndpoint() {
        TelefoneRequest createDto = new TelefoneRequest("99", "1234-5678");
        var response = given()
                        .contentType(ContentType.JSON)
                        .body(createDto)
                        .when().post("/telefones")
                        .then()
                        .statusCode(201)
                        .extract().response();
        
        Long idToDelete = response.jsonPath().getLong("id");
        given()
                .pathParam("id", idToDelete)
                .when().delete("/telefones/{id}")
                .then()
                .statusCode(200);
    }
}