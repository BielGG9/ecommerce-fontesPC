![Java](https://img.shields.io/badge/java-%23ED8B00.svg?style=for-the-badge&logo=openjdk&logoColor=white)
    ![Angular](https://img.shields.io/badge/angular-%23DD0031.svg?style=for-the-badge&logo=angular&logoColor=white)
    ![Quarkus](https://img.shields.io/badge/Quarkus-%234695EB.svg?style=for-the-badge&logo=Quarkus&logoColor=white)
    ```
    
# ⚡ Fontes PC - Sistema de Gestão de E-commerce

Este é um sistema de gerenciamento para e-commerce de fontes de PC, desenvolvido como parte do projeto **TP2** do curso de Sistemas de Informação. O projeto foca em uma arquitetura moderna com backend em microserviços e frontend responsivo, integrando autenticação robusta via Keycloak.

## 🛠️ Tecnologias Utilizadas

### **Backend**
*   **Java 21** com **Quarkus**.
*   **Hibernate ORM** com Panache.
*   **PostgreSQL** para persistência de dados.
*   **Keycloak** para autenticação e autorização (OIDC).

### **Frontend**
*   **Angular** com **TypeScript**.
*   **Bootstrap 5** para interface responsiva.
*   **Layout Moderno** com Sidebar retrátil e Dark Mode.

---

## 🚀 Funcionalidades Principais

*   **Painel Administrativo (Dashboard):** Visualização rápida de métricas e acesso fácil aos módulos.
*   **Gestão de CRUDs:** Gerenciamento completo de Fontes, Marcas, Modelos, Fornecedores e Funcionários.
*   **Segurança Avançada:** Proteção de rotas baseada em Roles (ADM/USER) via Keycloak.
*   **Infraestrutura:** Ambiente containerizado usando Docker Compose para Banco de Dados e Auth Server.

---

## 📦 Como Executar o Projeto

### **1. Pré-requisitos**
*   Docker e Docker Compose instalados.
*   Java 21 e Maven.
*   Node.js e Angular CLI.

### **2. Configurar Infraestrutura**
Na raiz do projeto, suba os containers do PostgreSQL e Keycloak:
```bash
docker-compose up -d
