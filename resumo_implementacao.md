# Relatório Geral de Implementação — Projeto FontesPC

Este documento apresenta o resumo detalhado de todas as alterações, implementações e integrações realizadas em todas as **6 Features** do sistema de e-commerce FontesPC (Quarkus + Angular + Keycloak).

---

## ⚡ Resumo por Feature

### 🔍 FEATURE 1 — Filtros na Home
Permite a pesquisa e filtragem de fontes por nome, marca e classificação de eficiência (certificação) diretamente na vitrine.
- **Backend:**
  - [FonteService.java](file:///f:/Backup/Downloads/ecommerce-fontesPC-main/backendTP2/src/main/java/gabriel/fontes/br/quarkus/Service/FonteService.java) e [FonteServiceImpl.java](file:///f:/Backup/Downloads/ecommerce-fontesPC-main/backendTP2/src/main/java/gabriel/fontes/br/quarkus/Service/FonteServiceImpl.java) atualizados para receber parâmetros de paginação e filtros (`nome`, `idMarca`, `categoria`), montando consultas dinâmicas no Panache.
  - [FonteResource.java](file:///f:/Backup/Downloads/ecommerce-fontesPC-main/backendTP2/src/main/java/gabriel/fontes/br/quarkus/Resource/FonteResource.java) expondo os endpoints atualizados e o método `/fontes/certificacoes` para retornar todas as opções do enum `Certificacao`.
- **Frontend:**
  - [home.component.ts](file:///f:/Backup/Downloads/ecommerce-fontesPC-main/frontTP2/src/app/components/home.component.ts) e [home.component.html](file:///f:/Backup/Downloads/ecommerce-fontesPC-main/frontTP2/src/app/components/home.component.html) atualizados com barra de filtros interativa (inputs, seletores de marca e certificações).
  - Trata o clique no card de produto redirecionando para a página de detalhes, enquanto o botão de compra é desacoplado via `$event.stopPropagation()`.

---

### 📦 FEATURE 2 — Detalhe do Produto
Exibição de informações completas da fonte selecionada em uma tela dedicada e responsiva.
- **Frontend:**
  - **Componente Standalone:** [produto-detalhe.component.ts](file:///f:/Backup/Downloads/ecommerce-fontesPC-main/frontTP2/src/app/components/produto-detalhe/produto-detalhe.component.ts) criado, gerenciando estados de carregamento (spinner), erro ou sucesso ao recuperar a fonte pelo ID.
  - **Template HTML:** [produto-detalhe.component.html](file:///f:/Backup/Downloads/ecommerce-fontesPC-main/frontTP2/src/app/components/produto-detalhe/produto-detalhe.component.html) estruturado em duas colunas (imagem | detalhes). Como a imagem é uma lista no DTO do backend, o template usa um fallback dinâmico: `fonte.nomeImagem || fonte.imagens[0].url`. A marca e a certificação também tratam tanto strings diretas como objetos.
  - **CSS:** [produto-detalhe.component.css](file:///f:/Backup/Downloads/ecommerce-fontesPC-main/frontTP2/src/app/components/produto-detalhe/produto-detalhe.component.css) com grid de duas colunas, estilo da marca e selos de estoque (`.badge-estoque`).
  - **Rotas:** Rota `/produto/:id` mapeada com lazy loading no arquivo [app.routes.ts](file:///f:/Backup/Downloads/ecommerce-fontesPC-main/frontTP2/src/app/app.routes.ts).

---

### ❤️ FEATURE 3 — Lista de Desejos (Wishlist)
Funcionalidade para salvar produtos favoritos, permitindo compra ou exclusão rápida.
- **Backend:**
  - **Model/Repository:** Entidade [Desejo.java](file:///f:/Backup/Downloads/ecommerce-fontesPC-main/backendTP2/src/main/java/gabriel/fontes/br/quarkus/Model/Desejo.java) (PanacheEntity) e [DesejoRepository.java](file:///f:/Backup/Downloads/ecommerce-fontesPC-main/backendTP2/src/main/java/gabriel/fontes/br/quarkus/Repository/DesejoRepository.java) criados para persistir a relação N:N.
  - **DTOs:** [DesejoRequest.java](file:///f:/Backup/Downloads/ecommerce-fontesPC-main/backendTP2/src/main/java/gabriel/fontes/br/quarkus/Dto/DesejoRequest.java) e [DesejoResponse.java](file:///f:/Backup/Downloads/ecommerce-fontesPC-main/backendTP2/src/main/java/gabriel/fontes/br/quarkus/Dto/DesejoResponse.java) criados.
  - **Service:** [DesejoService.java](file:///f:/Backup/Downloads/ecommerce-fontesPC-main/backendTP2/src/main/java/gabriel/fontes/br/quarkus/Service/DesejoService.java) e [DesejoServiceImpl.java](file:///f:/Backup/Downloads/ecommerce-fontesPC-main/backendTP2/src/main/java/gabriel/fontes/br/quarkus/Service/DesejoServiceImpl.java) implementam regras de negócio. Identificam o usuário via claim `subject` do JWT e buscam o cliente pelo `idKeycloak`. Lançam `409 Conflict` em caso de item duplicado na lista e `403 Forbidden` caso um usuário tente excluir um desejo de outra conta.
  - **Resource REST:** [DesejoResource.java](file:///f:/Backup/Downloads/ecommerce-fontesPC-main/backendTP2/src/main/java/gabriel/fontes/br/quarkus/Resource/DesejoResource.java) criado expondo `GET`, `POST` e `DELETE /{id}` sob a regra `@RolesAllowed({"USER", "ADM"})`.
- **Frontend:**
  - **Service:** [wishlist.service.ts](file:///f:/Backup/Downloads/ecommerce-fontesPC-main/frontTP2/src/app/services/wishlist.service.ts) criado com as chamadas HTTP.
  - **Componente:** Criados [wishlist.component.ts](file:///f:/Backup/Downloads/ecommerce-fontesPC-main/frontTP2/src/app/components/wishlist/wishlist.component.ts), [wishlist.component.html](file:///f:/Backup/Downloads/ecommerce-fontesPC-main/frontTP2/src/app/components/wishlist/wishlist.component.html) e [wishlist.component.css](file:///f:/Backup/Downloads/ecommerce-fontesPC-main/frontTP2/src/app/components/wishlist/wishlist.component.css) exibindo a lista e permitindo compra rápida ou deleção com feedbacks de diálogos/toasts.
  - **Rotas:** Rota `/minha-conta/favoritos` atualizada no [app.routes.ts](file:///f:/Backup/Downloads/ecommerce-fontesPC-main/frontTP2/src/app/app.routes.ts) para carregar o `WishlistComponent` com a proteção `canActivateUser`.

---

### 🎟️ FEATURE 4 — Cupom de Desconto
Aplicação de códigos promocionais com desconto no valor final do pedido.
- **Backend:**
  - **Model/Repository:** [Cupom.java](file:///f:/Backup/Downloads/ecommerce-fontesPC-main/backendTP2/src/main/java/gabriel/fontes/br/quarkus/Model/Cupom.java) (PanacheEntity) e [CupomRepository.java](file:///f:/Backup/Downloads/ecommerce-fontesPC-main/backendTP2/src/main/java/gabriel/fontes/br/quarkus/Repository/CupomRepository.java) criados.
  - **DTOs:** [CupomRequest.java](file:///f:/Backup/Downloads/ecommerce-fontesPC-main/backendTP2/src/main/java/gabriel/fontes/br/quarkus/Dto/CupomRequest.java) e [CupomResponse.java](file:///f:/Backup/Downloads/ecommerce-fontesPC-main/backendTP2/src/main/java/gabriel/fontes/br/quarkus/Dto/CupomResponse.java) criados.
  - **Service:** [CupomService.java](file:///f:/Backup/Downloads/ecommerce-fontesPC-main/backendTP2/src/main/java/gabriel/fontes/br/quarkus/Service/CupomService.java) e [CupomServiceImpl.java](file:///f:/Backup/Downloads/ecommerce-fontesPC-main/backendTP2/src/main/java/gabriel/fontes/br/quarkus/Service/CupomServiceImpl.java) criados. Caso o cupom esteja inativo ou não seja encontrado, retorna `valido = false` em vez de lançar exceções HTTP, deixando o controle para o frontend.
  - **Resource REST:** [CupomResource.java](file:///f:/Backup/Downloads/ecommerce-fontesPC-main/backendTP2/src/main/java/gabriel/fontes/br/quarkus/Resource/CupomResource.java) criado com endpoint público `POST /cupons/validar` (`@PermitAll`).
- **Frontend:**
  - **Service:** [cupom.service.ts](file:///f:/Backup/Downloads/ecommerce-fontesPC-main/frontTP2/src/app/services/cupom.service.ts) criado.
  - **Checkout:** [checkout.component.ts](file:///f:/Backup/Downloads/ecommerce-fontesPC-main/frontTP2/src/app/components/checkout/checkout.component.ts) e [checkout.component.html](file:///f:/Backup/Downloads/ecommerce-fontesPC-main/frontTP2/src/app/components/checkout/checkout.component.html) atualizados. O controle do formulário `cupom` foi inserido no group. O formulário do cupom foi encapsulado em `[formGroup]="checkoutForm"` localmente na coluna de resumo do pedido. O total a pagar é recalculado automaticamente e o código do cupom é anexado ao payload de criação do pedido em [pedido-request.model.ts](file:///f:/Backup/Downloads/ecommerce-fontesPC-main/frontTP2/src/app/models/pedido-request.model.ts).

---

### 📍 FEATURE 5 — Checkout: Endereço Existente
Permite que o usuário selecione um de seus endereços cadastrados no banco para entrega no checkout.
- **Backend:**
  - [EnderecoService.java](file:///f:/Backup/Downloads/ecommerce-fontesPC-main/backendTP2/src/main/java/gabriel/fontes/br/quarkus/Service/EnderecoService.java) e [EnderecoServiceImpl.java](file:///f:/Backup/Downloads/ecommerce-fontesPC-main/backendTP2/src/main/java/gabriel/fontes/br/quarkus/Service/EnderecoServiceImpl.java) atualizados com o método `findMeusEnderecos()`.
  - [EnderecoResource.java](file:///f:/Backup/Downloads/ecommerce-fontesPC-main/backendTP2/src/main/java/gabriel/fontes/br/quarkus/Resource/EnderecoResource.java) expondo `@GET /enderecos/meus` protegido para buscar os dados de endereço do usuário autenticado.
- **Frontend:**
  - [endereco.service.ts](file:///f:/Backup/Downloads/ecommerce-fontesPC-main/frontTP2/src/app/services/endereco.service.ts) atualizado com `getMeusEnderecos()`.
  - **Componente Checkout:** [checkout.component.ts](file:///f:/Backup/Downloads/ecommerce-fontesPC-main/frontTP2/src/app/components/checkout/checkout.component.ts) atualizado para inicializar carregando os endereços salvos do perfil. Se houver endereços, o formulário de preenchimento é ocultado (envolvido por `*ngIf="adicionandoNovoEndereco"` em [checkout.component.html](file:///f:/Backup/Downloads/ecommerce-fontesPC-main/frontTP2/src/app/components/checkout/checkout.component.html)) e os validadores dos inputs de novo endereço são limpos/redefinidos dinamicamente no método `updateEnderecoValidators()` para evitar o bloqueio de envio do form.
  - **CSS:** [checkout.component.css](file:///f:/Backup/Downloads/ecommerce-fontesPC-main/frontTP2/src/app/components/checkout/checkout.component.css) atualizado com a estilização `.endereco-card` e `.selecionado` para dar destaque ao endereço ativo.

---

### 🔑 FEATURE 6 — Alterar Senha no Perfil
Aba ou seção para o usuário logado alterar suas credenciais com segurança.
- **Backend:**
  - [ClienteResource.java](file:///f:/Backup/Downloads/ecommerce-fontesPC-main/backendTP2/src/main/java/gabriel/fontes/br/quarkus/Resource/ClienteResource.java) atualizado com o endpoint `@POST /clientes/alterar-senha` (que faz o intermédio de validação no Keycloak do usuário e altera a senha).
- **Frontend:**
  - [cliente.service.ts](file:///f:/Backup/Downloads/ecommerce-fontesPC-main/frontTP2/src/app/services/cliente.service.ts) atualizado para enviar a requisição de alteração de senha.
  - [dados.component.ts](file:///f:/Backup/Downloads/ecommerce-fontesPC-main/frontTP2/src/app/components/perfil/dados/dados.component.ts) e [dados.component.html](file:///f:/Backup/Downloads/ecommerce-fontesPC-main/frontTP2/src/app/components/perfil/dados/dados.component.html) atualizados, integrando validações de formulário reativo (`senhaForm`), com regras de tamanho mínimo de 6 dígitos e validator de senha igual para a confirmação.

---

## 🛠️ Status da Compilação e Builds
Toda a base de código do sistema está estruturada e compilando sem erros:
- **Backend (Quarkus):** `./mvnw clean compile` finaliza com status `BUILD SUCCESS` e todas as entidades e endpoints REST foram registrados.
- **Frontend (Angular):** `npx ng build` finaliza sem erros e empacota os bundles em chunks lazy-loaded, incluindo o novo componente da wishlist (`wishlist-component`).
