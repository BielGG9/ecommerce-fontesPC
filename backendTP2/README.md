# ⚡ Fontes Store API

Este projeto é uma API REST robusta desenvolvida para o gerenciamento de um e-commerce especializado em **Fontes de Alimentação para PC (PSUs)**.

O sistema gerencia todo o fluxo de vendas, desde o cadastro de produtos técnicos (marcas, modelos, certificações) até o processamento de pedidos com baixa de estoque e controle de usuários via autenticação moderna.

---

## 🚀 Tecnologias Utilizadas

O projeto foi construído utilizando as melhores práticas do ecossistema Java moderno:

* **[Quarkus](https://quarkus.io/):** Framework Supersonic Subatomic Java.
* **Java 21:** Linguagem base.
* **PostgreSQL:** Banco de dados relacional.
* **Hibernate ORM com Panache:** Persistência de dados simplificada (Active Record/Repository).
* **Keycloak (OIDC):** Servidor de Identidade e Gestão de Acesso (IAM).
* **Docker:** Containerização do banco de dados e Keycloak.
* **Swagger UI (OpenAPI):** Documentação interativa da API.
* **JUnit 5 & RestAssured:** Testes unitários e de integração.

---

## 📦 Funcionalidades do Sistema

### 🛒 Gestão de Produtos (Catálogo)
* **Fontes:** Cadastro detalhado com potência (W), preço, estoque e certificação (Bronze, Silver, Gold, etc).
* **Marcas e Modelos:** Organização hierárquica dos produtos.
* **Fornecedores:** Gestão de quem fornece os produtos (Relacionamento Many-to-Many).

### 👤 Gestão de Usuários
* **Perfis de Acesso:** Separação entre `ADM` (Administrador) e `USER` (Cliente).
* **Hierarquia de Pessoas:**
    * **Cliente:** Possui histórico de compras e dados pessoais.
    * **Funcionário:** Vinculado a departamentos (TI, Vendas, etc).
* **Integração OAuth2:** Login seguro via Token JWT gerado pelo Keycloak.

### 🛍️ Fluxo de Pedidos (Core Business)
* **Carrinho de Compras:** Adição de múltiplos itens em um único pedido.
* **Validação de Estoque:** O sistema impede vendas se não houver estoque suficiente.
* **Snapshot de Preço:** O preço do item é gravado no momento da compra (proteção contra alteração futura de preços).
* **Snapshot de Endereço:** O endereço de entrega é copiado para o pedido, garantindo histórico mesmo se o cliente mudar de casa.
* **Histórico:** O cliente visualiza apenas os seus próprios pedidos.

---

## 🛠️ Como Rodar o Projeto

### 1. Pré-requisitos
* JDK 17 ou 21+
* Docker (para subir o Banco e o Keycloak)
* Maven

### 2. Subindo a Infraestrutura (Docker)
Antes de iniciar a aplicação, você precisa do PostgreSQL e do Keycloak rodando.

**PostgreSQL:**
```shell
docker run --name postgres-db -e POSTGRES_USER=bieltp1 -e POSTGRES_PASSWORD=150326 -e POSTGRES_DB=gbtp1 -p 5432:5432 -d postgres
