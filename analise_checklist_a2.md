# 📋 Análise do Checklist A2 — FontesPC
### Projeto: E-commerce de Fontes de Alimentação (Angular + Quarkus)

---

## ✅ O QUE VOCÊ FEZ (Implementado)

### 🏠 Página Principal — Produtos com Card e Filtro
**STATUS: ✅ FEITO COMPLETO**

- **Cards de produto** com imagem, nome, marca, potência, certificação, estoque e preço
- **Filtro por nome** (query param `nome`)
- **Filtro por marca** (query param `marca`)
- **Filtro por categoria** (query param `categoria`)
- Paginação backend com `page` e `pageSize`
- Indicação de produto esgotado
- Botão "Adicionar ao Carrinho" diretamente na vitrine
- Banner de Cadastro Expresso na home

---

### 📄 Página de Detalhe do Produto
**STATUS: ✅ FEITO COMPLETO**

- Exibição completa: nome, preço, potência, marca, certificação, estoque
- **Galeria de imagens com slider** (botões anterior/próximo, dots, swipe touch)
- Miniaturas clicáveis
- Botão **"Comprar Agora"** (adiciona ao carrinho e redireciona)
- Botão **"Adicionar ao Carrinho"**
- Botão **"Adicionar aos Desejos"** (integrado com Wishlist)
- Estados: carregando, erro, produto não encontrado
- Breadcrumb de navegação

---

### ❤️ Lista de Desejos (Wishlist)
**STATUS: ✅ FEITO (com ressalva)**

- **Usuário deve estar logado** para adicionar aos desejos ✅
- Exibe os produtos desejados com imagem, nome e preço
- Botão para adicionar ao carrinho direto da wishlist
- Botão para remover da wishlist
- **Relacionamento n → n** (Cliente ↔ Fonte via entidade `Desejo`) ✅
- Backend: `DesejoResource` com endpoints REST e `Desejo.java` com relacionamento

---

### 🎟️ Cupom de Desconto
**STATUS: ✅ FEITO**

- Campo de cupom na tela de **Checkout** (lado direito do resumo)
- Backend: entidade `Cupom.java` com campos `codigo`, `porcentagem` e `ativo`
- `CupomResource.java` presente
- Feedback visual: ✅ cupom aplicado (% desconto) ou ❌ erro
- Cálculo do total com desconto exibido na tela

---

### 🛒 Tela de Carrinho de Compras
**STATUS: ✅ FEITO COMPLETO**

- Lista de itens com imagem, nome, quantidade e subtotal
- Controles de aumentar/diminuir quantidade (respeitando estoque)
- Remoção de itens individuais e limpeza total
- Cálculo de total
- Botão **"Finalizar Compra"** com verificação de login
- Modal de **Completar Cadastro** para usuários do Cadastro Expresso (CPF, CEP, telefone)

---

### 🔑 Tela de Login
**STATUS: ✅ FEITO COMPLETO**

- Formulário com email e senha (Angular Material)
- Validação de campos com mensagens de erro
- Integração com **Keycloak** (JWT)
- Link **"Esqueceu a senha?"** → rota `/recuperar-senha` ✅

---

### 🔓 Esqueceu a Senha?
**STATUS: ✅ FEITO**

- Tela de recuperação de senha (`recuperar-senha.component`)
- Campo de e-mail com validação
- Backend: endpoint `POST /clientes/esqueci-senha` que aciona o Keycloak para enviar e-mail de recuperação
- Feedback de sucesso e erro na tela

---

### 💳 Tela de Finalizar Compra (Checkout)
**STATUS: ✅ FEITO COMPLETO**

- **Seleção de endereço** de entrega (endereços já cadastrados + opção de adicionar novo) ✅
- Opção de salvar o novo endereço
- **Forma de pagamento** com 3 opções: ✅
  - **PIX** (exibe QR Code simulado)
  - **Boleto**
  - **Cartão de Crédito** (formulário completo: número, nome, validade, CVV)
- Cartões salvos aparecem para seleção
- Cupom de desconto integrado
- Resumo lateral com itens, quantidades e total

---

### 📦 Tela de Resumo da Compra / Finalização
**STATUS: ✅ FEITO COMPLETO**

- Tela dedicada "Pedido Confirmado" adicionada como passo final do checkout (`/pedido-confirmado`).
- Pedido é criado via backend ao finalizar o checkout
- Resumo do último pedido visível no **Painel do Perfil**
- Histórico de pedidos com detalhes expandíveis (itens, endereço de entrega, forma de pagamento)
- `PedidoResource.java` e `Pedido.java` implementados com `ItemPedido`, `EnderecoEntrega`

---

### 🛡️ Parte Administrativa
**STATUS: ✅ FEITO COMPLETO**

- Dashboard administrativo com sidebar colapsável
- Cards de estatísticas: Total Fontes, Marcas, Vendas Diárias (valor e quantidade)
- Acesso rápido para todos os módulos
- Dark/Light mode
- Módulos implementados:
  - **Fonte** (CRUD completo com upload de imagem)
  - **Marca** (CRUD)
  - **Modelo** (CRUD)
  - **Departamento** (CRUD)
  - **Fornecedor** (CRUD)
  - **Funcionário** (CRUD)
  - **Cupom** (CRUD via backend)
- Proteção por role `ADM` nos endpoints críticos

---

### 📸 Upload de Imagem
**STATUS: ✅ FEITO COMPLETO**

- **Upload de imagem de produto** (Admin): `PATCH /fontes/image/upload` com `FileUpload`
- **Upload de avatar do usuário** (Perfil): `PATCH /clientes/image/upload`
- Armazenamento via **MinIO** (S3-compatible): `S3StorageService`
- Entidade `Arquivo.java` para gerenciar metadados de arquivos
- Download de imagens via endpoints dedicados

---

### 📝 Tela de Cadastro de Usuário (Não é CRUD)
**STATUS: ✅ FEITO**

- Tela de **Cadastro Expresso** (nome, e-mail, senha)
- Não é CRUD administrativo — é auto-cadastro pelo usuário ✅
- Integração com Keycloak para criação do usuário
- Banner de convite ao cadastro na home e na página de produto

---

### 👤 Perfil do Usuário Logado
**STATUS: ✅ FEITO MUITO COMPLETO**

O perfil tem uma estrutura rica com múltiplas sub-abas:

#### Dados Completos do Usuário ✅
- Nome, e-mail, CPF, RG, username
- CPF/RG bloqueados para edição direta → requer **confirmação de senha** (modal de segurança)
- Campos: telefone, endereço acessíveis via abas separadas

#### Alteração de Senha ✅
- Modal dedicado com campos: senha atual, nova senha, confirmar nova senha
- Validação de campos e mensagens de erro
- Backend: `POST /clientes/alterar-senha` (protegido por JWT, exige senha atual)

#### Alteração no perfil mediante confirmação de senha ✅
- Modal de segurança para desbloquear campos sensíveis (CPF, RG)
- Confirmação de senha antes de liberar a edição

#### Histórico de Compras Já Realizadas ✅
- Tela de "Meus Pedidos" com tabela expandível
- Exibe: número do pedido, data, valor total, status
- Detalhe expandível: itens, endereço de entrega, forma de pagamento

#### Extras implementados:
- Endereços gerenciáveis (`/minha-conta/enderecos`)
- Cartões salvos (`/minha-conta/cartoes`)
- Telefones (`/minha-conta/telefones`)
- Favoritos/Wishlist (`/minha-conta/favoritos`)
- Upload de foto de perfil (avatar com MinIO)

---

---

## 📊 RESUMO GERAL

| Item do Checklist | Status |
|---|---|
| Página principal com cards e filtro | ✅ Completo |
| Página detalhe do produto | ✅ Completo |
| Adicionar ao carrinho (detalhe) | ✅ Completo |
| Adicionar à lista de desejos | ✅ Completo |
| Lista de desejos (login obrigatório, n→n) | ✅ Completo |
| Cupom de desconto | ✅ Completo |
| Tela de carrinho de compras | ✅ Completo |
| Tela de login | ✅ Completo |
| Esqueceu a senha? | ✅ Completo |
| Tela de finalizar compra | ✅ Completo |
| Selecionar endereço | ✅ Completo |
| Forma de pagamento | ✅ Completo |
| Tela de resumo da compra | ✅ Completo |
| Finaliza a compra | ✅ Completo (backend) |
| Parte administrativa | ✅ Completo |
| Upload de imagem | ✅ Completo |
| Cadastro de usuário (não CRUD) | ✅ Completo |
| Perfil com dados completos (telefone, endereço) | ✅ Completo |
| Alteração de senha | ✅ Completo |
| Alteração com confirmação de senha | ✅ Completo |
| Histórico de compras | ✅ Completo |

**Estimativa: 21/21 itens implementados → 100% do checklist concluído** 🎉

---

---

# 🎬 ROTEIRO DE APRESENTAÇÃO EM VÍDEO

> **Duração sugerida:** 8 a 12 minutos  
> **Tom:** Objetivo, confiante e demonstrativo  
> **Estrutura:** Mostrar na tela cada funcionalidade enquanto explica

---

## 🎙️ ABERTURA (30 segundos)

> *[Tela: Página inicial do sistema aberta no browser]*

**Fala:**
> "Olá professor! Meu nome é [seu nome] e vou apresentar o trabalho da A2 de Tópicos II — um e-commerce completo de fontes de alimentação para PC, chamado **FontesPC**. O sistema foi desenvolvido com **Angular no front-end**, **Quarkus no back-end** e **Keycloak** para autenticação. Vou percorrer cada item do checklist mostrando ao vivo."

---

## 1️⃣ PÁGINA PRINCIPAL — Cards e Filtro (1 min)

> *[Tela: Home page com grid de produtos]*

**Fala:**
> "A página principal exibe os produtos em cards, com imagem, nome da marca, potência, certificação e preço. O sistema suporta **filtragem por nome, marca e categoria**, que funcionam via query parameters na URL. Aqui eu digito na barra de busca... [demonstrar] e os produtos filtram em tempo real consultando o back-end. Ao clicar em qualquer produto, vou para a página de detalhe."

---

## 2️⃣ PÁGINA DE DETALHE DO PRODUTO (1 min)

> *[Tela: Clicar em um produto e abrir a página de detalhe]*

**Fala:**
> "Na página de detalhe temos: galeria de imagens com slider — [clicar nas setas ou dots] — especificações técnicas como potência, marca e certificação, indicação de estoque e o preço. Temos dois botões de ação: **Comprar Agora**, que adiciona ao carrinho e leva direto para lá, e **Adicionar ao Carrinho** para continuar comprando. Existe também o botão de **adicionar aos favoritos**, que vou mostrar em seguida."

---

## 3️⃣ LISTA DE DESEJOS / WISHLIST (45 seg)

> *[Tela: Clicar em "Adicionar aos Desejos" estando logado]*

**Fala:**
> "A lista de desejos exige que o usuário esteja **logado**. Ao tentar adicionar sem login, o sistema redireciona para a tela de login. Com o usuário autenticado, o produto é adicionado. O relacionamento é **muitos para muitos** — um cliente pode ter vários produtos desejados, e um produto pode estar na lista de vários clientes. A wishlist fica acessível no perfil do usuário, onde é possível adicionar ao carrinho ou remover."

---

## 4️⃣ CUPOM DE DESCONTO (30 seg)

> *[Tela: Tela de Checkout, campo de cupom no lado direito]*

**Fala:**
> "O sistema possui **cupons de desconto**. Na tela de checkout, há um campo para inserir o código do cupom. Ao aplicar, o sistema consulta o back-end, valida o cupom e exibe a porcentagem de desconto aplicada. O total é recalculado automaticamente mostrando o preço original e o preço com desconto."

---

## 5️⃣ TELA DE CARRINHO (45 seg)

> *[Tela: Acessar o carrinho com itens]*

**Fala:**
> "A tela do carrinho exibe todos os produtos adicionados com imagem, quantidade e subtotal. É possível **aumentar ou diminuir a quantidade** — respeitando o estoque disponível — e **remover itens**. O total é calculado em tempo real. Ao clicar em Finalizar Compra, o sistema verifica se o usuário está logado antes de prosseguir."

---

## 6️⃣ TELA DE LOGIN E RECUPERAÇÃO DE SENHA (45 seg)

> *[Tela: Tela de login]*

**Fala:**
> "A tela de login possui validação de campos com mensagens de erro. A autenticação é feita com **Keycloak e JWT**. Na parte de baixo temos o link **'Esqueci a minha senha'**, que leva para uma tela de recuperação — o usuário informa o e-mail e o sistema dispara um link de redefinição de senha via Keycloak. [Mostrar a tela de recuperar senha brevemente]."

---

## 7️⃣ TELA DE FINALIZAR COMPRA / CHECKOUT (1 min 30 seg)

> *[Tela: Tela de Checkout com os dois painéis]*

**Fala:**
> "A tela de checkout é dividida em duas partes. **À esquerda:** dados do pedido — nome do destinatário, **seleção do endereço de entrega** entre os endereços já cadastrados ou com opção de adicionar um novo e salvá-lo para compras futuras. Logo abaixo, a **forma de pagamento**: PIX [mostrar QR Code], Boleto ou Cartão de Crédito. Para cartão, é possível usar um cartão já salvo ou cadastrar um novo, com opção de salvar. **À direita:** resumo dos itens, campo de cupom e total. Ao finalizar, o pedido é processado pelo back-end."

---

## 8️⃣ TELA DE RESUMO / CONFIRMAÇÃO (30 seg)

> *[Tela: Perfil do usuário após compra, seção "Último Pedido"]*

**Fala:**
> "Após a finalização, o pedido fica registrado. No perfil do usuário, o painel principal já exibe um **resumo do último pedido**. Na aba de 'Meus Pedidos', o usuário vê o **histórico completo** com todos os pedidos, podendo expandir cada um para ver os itens, o endereço de entrega e a forma de pagamento utilizada."

---

## 9️⃣ PARTE ADMINISTRATIVA (1 min)

> *[Tela: Dashboard administrativo]*

**Fala:**
> "O sistema possui uma **área administrativa** completa. O dashboard mostra estatísticas em tempo real: total de fontes, marcas e vendas diárias. A sidebar tem acesso a todos os módulos de gestão: Fontes, Marcas, Modelos, Departamentos, Fornecedores e Funcionários — todos com CRUD completo. Os endpoints do admin são protegidos pela role ADM no back-end."

---

## 🖼️ UPLOAD DE IMAGEM (30 seg)

> *[Tela: Admin → Fontes → Editar uma fonte → Upload de imagem]*

**Fala:**
> "O **upload de imagem** é feito tanto para os produtos quanto para o avatar do usuário. No admin, ao cadastrar ou editar uma fonte, é possível fazer upload de múltiplas imagens. Os arquivos são armazenados no **MinIO** — uma solução de armazenamento de objetos compatível com S3."

---

## 👤 CADASTRO DE USUÁRIO E PERFIL (1 min 30 seg)

> *[Tela: Página de Cadastro → Perfil → Meus Dados]*

**Fala:**
> "O cadastro de usuário **não é um CRUD administrativo** — é um auto-cadastro pelo próprio usuário. Temos o **Cadastro Expresso** com apenas nome, e-mail e senha. No perfil, o usuário tem acesso a dados completos: nome, CPF, RG, username. **Campos sensíveis como CPF e RG são bloqueados e só podem ser alterados após confirmar a senha** — veja o modal de segurança [mostrar o modal]. Para **alterar a senha**, há um link que abre um formulário específico com senha atual, nova senha e confirmação. E no painel do perfil, o usuário acessa **endereços, cartões, telefones, favoritos e histórico de pedidos** — uma central completa."

---

## 🏁 ENCERRAMENTO (30 segundos)

> *[Tela: Home page novamente ou Dashboard]*

**Fala:**
> "Resumindo, implementamos praticamente todos os itens do checklist: página principal com filtro, detalhe do produto, lista de desejos com controle de login, cupom de desconto, carrinho, login com recuperação de senha, checkout completo com endereço e formas de pagamento, histórico de compras, parte administrativa com CRUD e upload de imagem, cadastro de usuário e um perfil completo com alteração de senha e confirmação. Obrigado professor!"

---

## 💡 DICAS PARA A GRAVAÇÃO

1. **Tenha o sistema rodando** (backend + frontend) antes de iniciar
2. **Crie um usuário de teste** e tenha um pedido já feito para mostrar o histórico
3. **Tenha um cupom válido** cadastrado no banco para demonstrar
4. **Use um produto com imagem** cadastrado para mostrar o slider
5. **Grave em tela cheia** sem notificações do sistema
6. **Fale pausado** — vale mais mostrar funcionando do que falar rápido
