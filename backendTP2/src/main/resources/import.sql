-- CONFIGURAÇÕES INICIAIS
-- Sequências para garantir IDs consistentes
SELECT setval('pessoa_id_seq', 30, true);
SELECT setval('departamento_id_seq', 20, true);
SELECT setval('marca_id_seq', 20, true);
SELECT setval('modelo_id_seq', 20, true);
SELECT setval('enderecos_id_seq', 20, true);
SELECT setval('telefones_id_seq', 20, true);
SELECT setval('fonte_id_seq', 20, true);
-- Reseta as sequências de pedido para começar do 1 quando você criar via API
SELECT setval('pedido_id_seq', 1, false);
SELECT setval('item_pedido_id_seq', 1, false);
SELECT setval('cartao_id_seq', 10, true);


-- 1. MARCAS (10)
INSERT INTO marca(id, nome) VALUES(1, 'Corsair'); 
INSERT INTO marca(id, nome) VALUES(2, 'Seasonic');
INSERT INTO marca(id, nome) VALUES(3, 'EVGA');
INSERT INTO marca(id, nome) VALUES(4, 'Thermaltake');
INSERT INTO marca(id, nome) VALUES(5, 'Cooler Master');
INSERT INTO marca(id, nome) VALUES(6, 'XPG');
INSERT INTO marca(id, nome) VALUES(7, 'Gigabyte');
INSERT INTO marca(id, nome) VALUES(8, 'Pichau');
INSERT INTO marca(id, nome) VALUES(9, 'Super Flower');
INSERT INTO marca(id, nome) VALUES(10, 'Redragon');

-- 2. MODELOS (10)
INSERT INTO modelo(id, numeracao, marca_id) VALUES(1, 750, 1);
INSERT INTO modelo(id, numeracao, marca_id) VALUES(2, 1000, 2); 
INSERT INTO modelo(id, numeracao, marca_id) VALUES(3, 850, 3); 
INSERT INTO modelo(id, numeracao, marca_id) VALUES(4, 600, 4); 
INSERT INTO modelo(id, numeracao, marca_id) VALUES(5, 500, 5); 
INSERT INTO modelo(id, numeracao, marca_id) VALUES(6, 650, 6); 
INSERT INTO modelo(id, numeracao, marca_id) VALUES(7, 450, 7); 
INSERT INTO modelo(id, numeracao, marca_id) VALUES(8, 550, 8); 
INSERT INTO modelo(id, numeracao, marca_id) VALUES(9, 1200, 9); 
INSERT INTO modelo(id, numeracao, marca_id) VALUES(10, 800, 10); 

-- 3. FONTES (10)
INSERT INTO fonte(id, nome, potencia, preco, estoque, certificacao, modelo_id) VALUES(1, 'RM750x', 750, 800.00, 50, 'GOLD', 1);
INSERT INTO fonte(id, nome, potencia, preco, estoque, certificacao, modelo_id) VALUES(2, 'Prime TX-1000', 1000, 1500.00, 20, 'TITANIUM', 2);
INSERT INTO fonte(id, nome, potencia, preco, estoque, certificacao, modelo_id) VALUES(3, 'SuperNOVA 850', 850, 950.00, 30, 'GOLD', 3);
INSERT INTO fonte(id, nome, potencia, preco, estoque, certificacao, modelo_id) VALUES(4, 'Smart 600W', 600, 350.00, 150, 'WHITE', 4);
INSERT INTO fonte(id, nome, potencia, preco, estoque, certificacao, modelo_id) VALUES(5, 'MWE Bronze 500', 500, 280.00, 100, 'BRONZE', 5);
INSERT INTO fonte(id, nome, potencia, preco, estoque, certificacao, modelo_id) VALUES(6, 'Core Reactor 650', 650, 600.00, 45, 'GOLD', 6);
INSERT INTO fonte(id, nome, potencia, preco, estoque, certificacao, modelo_id) VALUES(7, 'P450B', 450, 220.00, 200, 'BRONZE', 7);
INSERT INTO fonte(id, nome, potencia, preco, estoque, certificacao, modelo_id) VALUES(8, 'Nidus 550', 550, 300.00, 80, 'BRONZE', 8);
INSERT INTO fonte(id, nome, potencia, preco, estoque, certificacao, modelo_id) VALUES(9, 'Leadex Platinum', 1200, 1800.00, 10, 'PLATINUM', 9);
INSERT INTO fonte(id, nome, potencia, preco, estoque, certificacao, modelo_id) VALUES(10, 'RPGS 800W', 800, 550.00, 60, 'BRONZE', 10);

-- 4. DEPARTAMENTOS (10)
INSERT INTO departamento(id, sigla, descricao) VALUES (1, 'VND', 'Vendas');
INSERT INTO departamento(id, sigla, descricao) VALUES (2, 'TI', 'Tecnologia');
INSERT INTO departamento(id, sigla, descricao) VALUES (3, 'ADM', 'Administração');
INSERT INTO departamento(id, sigla, descricao) VALUES (4, 'MKT', 'Marketing');
INSERT INTO departamento(id, sigla, descricao) VALUES (5, 'LOG', 'Logística');
INSERT INTO departamento(id, sigla, descricao) VALUES (6, 'RH', 'Recursos Humanos');
INSERT INTO departamento(id, sigla, descricao) VALUES (7, 'FIN', 'Financeiro');
INSERT INTO departamento(id, sigla, descricao) VALUES (8, 'SUP', 'Suporte Técnico');
INSERT INTO departamento(id, sigla, descricao) VALUES (9, 'OPE', 'Operações');
INSERT INTO departamento(id, sigla, descricao) VALUES (10, 'SAC', 'Atendimento ao Consumidor');


-- 5. PESSOAS (Cliente Base)
-- NOTA DE SEGURANÇA: Dados pessoais e UUID real do Keycloak foram removidos do import.sql.
-- Usando um cliente genérico de testes apenas para satisfazer as FKs de Cartão/Endereço.
INSERT INTO Pessoa(id, nome, email, idKeycloak) VALUES (1, 'Cliente Teste', 'cliente@teste.com', '00000000-0000-0000-0000-000000000000');
INSERT INTO PessoaFisica(id, cpf, rg) VALUES (1, '11111111111', '12345 SSP/SP');
INSERT INTO Cliente(id, dataCadastro) VALUES (1, '2025-01-01T10:00:00');

-- 6. FORNECEDORES (10) - IDs 2 a 11
INSERT INTO Pessoa(id, nome, email) VALUES (2, 'Tech Distribuidora', 'contato@tech.com');
INSERT INTO PessoaJuridica(id, cnpj, inscricaoEstadual) VALUES (2, '99.999.999/0001-99', 'ISENTO');
INSERT INTO Fornecedor(id, razaoSocial) VALUES (2, 'Tech Distribuidora Ltda');

INSERT INTO Pessoa(id, nome, email) VALUES (3, 'Giga Parts', 'vendas@gigaparts.com');
INSERT INTO PessoaJuridica(id, cnpj, inscricaoEstadual) VALUES (3, '88.888.888/0001-88', '123456');
INSERT INTO Fornecedor(id, razaoSocial) VALUES (3, 'Giga Parts Importação SA');

INSERT INTO Pessoa(id, nome, email) VALUES (4, 'Mundo PC', 'mundopc@fornecedor.com');
INSERT INTO PessoaJuridica(id, cnpj, inscricaoEstadual) VALUES (4, '77.777.777/0001-77', 'ISENTO');
INSERT INTO Fornecedor(id, razaoSocial) VALUES (4, 'Mundo do PC Atacadista');

INSERT INTO Pessoa(id, nome, email) VALUES (5, 'Hardware Express', 'atendimento@hwexpress.com');
INSERT INTO PessoaJuridica(id, cnpj, inscricaoEstadual) VALUES (5, '66.666.666/0001-66', '654321');
INSERT INTO Fornecedor(id, razaoSocial) VALUES (5, 'Hardware Xpress Distribuição');

INSERT INTO Pessoa(id, nome, email) VALUES (6, 'Atacado Info', 'sac@atacadoinfo.com');
INSERT INTO PessoaJuridica(id, cnpj, inscricaoEstadual) VALUES (6, '55.555.555/0001-55', 'ISENTO');
INSERT INTO Fornecedor(id, razaoSocial) VALUES (6, 'Atacado de Informatica ME');

INSERT INTO Pessoa(id, nome, email) VALUES (7, 'Componentes BR', 'br@componentes.com');
INSERT INTO PessoaJuridica(id, cnpj, inscricaoEstadual) VALUES (7, '44.444.444/0001-44', 'ISENTO');
INSERT INTO Fornecedor(id, razaoSocial) VALUES (7, 'Componentes BR Ltda');

INSERT INTO Pessoa(id, nome, email) VALUES (8, 'Gamer Suprimentos', 'fornecedor@gamersupri.com.br');
INSERT INTO PessoaJuridica(id, cnpj, inscricaoEstadual) VALUES (8, '33.333.333/0001-33', '987654');
INSERT INTO Fornecedor(id, razaoSocial) VALUES (8, 'Suprimentos Gamer do Brasil');

INSERT INTO Pessoa(id, nome, email) VALUES (9, 'Energy Components', 'sac@energycomp.com');
INSERT INTO PessoaJuridica(id, cnpj, inscricaoEstadual) VALUES (9, '22.222.222/0001-22', 'ISENTO');
INSERT INTO Fornecedor(id, razaoSocial) VALUES (9, 'Energy Power Components');

INSERT INTO Pessoa(id, nome, email) VALUES (10, 'Nerd Store B2B', 'nerdstore@b2b.com');
INSERT INTO PessoaJuridica(id, cnpj, inscricaoEstadual) VALUES (10, '11.111.111/0002-11', 'ISENTO');
INSERT INTO Fornecedor(id, razaoSocial) VALUES (10, 'Nerd Store Wholesale');

INSERT INTO Pessoa(id, nome, email) VALUES (11, 'Varejo das Fontes', 'vdf@fontes.com');
INSERT INTO PessoaJuridica(id, cnpj, inscricaoEstadual) VALUES (11, '10.101.101/0001-01', 'ISENTO');
INSERT INTO Fornecedor(id, razaoSocial) VALUES (11, 'Varejo e Distribuição das Fontes');

-- 7. FUNCIONÁRIOS (10) - IDs 12 a 21
INSERT INTO Pessoa(id, nome, email) VALUES (12, 'Ana Dev', 'ana@email.com');
INSERT INTO PessoaFisica(id, cpf, rg) VALUES (12, '22222222222', '54321 SSP/RJ');
INSERT INTO Funcionario(id, cargo, departamento_id, password, dataAdmissao) VALUES (12, 'Desenvolvedora', 2, 'password', '2020-01-15');

INSERT INTO Pessoa(id, nome, email) VALUES (13, 'Pedro Vendas', 'pedro@email.com');
INSERT INTO PessoaFisica(id, cpf, rg) VALUES (13, '33333333333', '12312 SSP/SP');
INSERT INTO Funcionario(id, cargo, departamento_id, password, dataAdmissao) VALUES (13, 'Vendedor Sr', 1, 'password', '2019-05-20');

INSERT INTO Pessoa(id, nome, email) VALUES (14, 'Carlos Suporte', 'carlos@email.com');
INSERT INTO PessoaFisica(id, cpf, rg) VALUES (14, '44444444444', '31231 SSP/MG');
INSERT INTO Funcionario(id, cargo, departamento_id, password, dataAdmissao) VALUES (14, 'Atendente', 8, 'password', '2021-08-10');

INSERT INTO Pessoa(id, nome, email) VALUES (15, 'Maria Financeiro', 'maria@email.com');
INSERT INTO PessoaFisica(id, cpf, rg) VALUES (15, '55555555555', '87654 SSP/SP');
INSERT INTO Funcionario(id, cargo, departamento_id, password, dataAdmissao) VALUES (15, 'Contadora', 7, 'password', '2018-03-12');

INSERT INTO Pessoa(id, nome, email) VALUES (16, 'Jorge Logistica', 'jorge@email.com');
INSERT INTO PessoaFisica(id, cpf, rg) VALUES (16, '66666666666', '88888 SSP/BA');
INSERT INTO Funcionario(id, cargo, departamento_id, password, dataAdmissao) VALUES (16, 'Gerente de Logística', 5, 'password', '2017-11-05');

INSERT INTO Pessoa(id, nome, email) VALUES (17, 'Aline Marketing', 'aline@email.com');
INSERT INTO PessoaFisica(id, cpf, rg) VALUES (17, '77777777777', '77777 SSP/TO');
INSERT INTO Funcionario(id, cargo, departamento_id, password, dataAdmissao) VALUES (17, 'Designer', 4, 'password', '2022-02-28');

INSERT INTO Pessoa(id, nome, email) VALUES (18, 'Roberto RH', 'roberto@email.com');
INSERT INTO PessoaFisica(id, cpf, rg) VALUES (18, '88888888888', '66666 SSP/RS');
INSERT INTO Funcionario(id, cargo, departamento_id, password, dataAdmissao) VALUES (18, 'Analista de RH', 6, 'password', '2020-07-15');

INSERT INTO Pessoa(id, nome, email) VALUES (19, 'Fernanda Admin', 'fernanda@email.com');
INSERT INTO PessoaFisica(id, cpf, rg) VALUES (19, '99999999999', '55555 SSP/DF');
INSERT INTO Funcionario(id, cargo, departamento_id, password, dataAdmissao) VALUES (19, 'Diretora Geral', 3, 'password', '2015-01-01');

INSERT INTO Pessoa(id, nome, email) VALUES (20, 'Marcos Operacional', 'marcos@email.com');
INSERT INTO PessoaFisica(id, cpf, rg) VALUES (20, '10101010101', '44444 SSP/PR');
INSERT INTO Funcionario(id, cargo, departamento_id, password, dataAdmissao) VALUES (20, 'Estoquista', 9, 'password', '2023-04-10');

INSERT INTO Pessoa(id, nome, email) VALUES (21, 'Leticia SAC', 'leticia@email.com');
INSERT INTO PessoaFisica(id, cpf, rg) VALUES (21, '20202020202', '33333 SSP/GO');
INSERT INTO Funcionario(id, cargo, departamento_id, password, dataAdmissao) VALUES (21, 'Supervisora de SAC', 10, 'password', '2019-09-01');


-- 8. ENDEREÇOS E TELEFONES DO CLIENTE
INSERT INTO enderecos(id, rua, numero, complemento, bairro, cidade, estado, cep, pessoa_id) 
VALUES (1, 'Rua das Flores', '10', 'Apto 1', 'Centro', 'Palmas', 'TO', '77000-000', 1);
INSERT INTO telefones(id, ddd, numero, pessoa_id) 
VALUES (1, '63', '98765-4321', 1);


-- 9. CARTÕES DO CLIENTE (Já cadastrados para você usar no teste)
INSERT INTO pagamento (id, status) VALUES (1, 'ATIVO');
INSERT INTO cartao (id, numeroCartao, nomeImpresso, validadeCartao, cvv, id_cliente)
VALUES (1, '1234567890123456', 'GABRIEL BIEL', '12/2029', '123', 1);

INSERT INTO pagamento (id, status) VALUES (2, 'ATIVO');
INSERT INTO cartao (id, numeroCartao, nomeImpresso, validadeCartao, cvv, id_cliente)
VALUES (2, '9876543210987654', 'CARTAO TESTE 2', '10/2030', '999', 1);


-- 10. RELAÇÕES FORNECEDOR -> FONTE (N:N)
-- Associando cada fonte a pelo menos um fornecedor para popular a tabela de relacionamento
INSERT INTO fonte_fornecedor(fonte_id, fornecedor_id) VALUES (1, 2);
INSERT INTO fonte_fornecedor(fonte_id, fornecedor_id) VALUES (2, 3);
INSERT INTO fonte_fornecedor(fonte_id, fornecedor_id) VALUES (3, 4);
INSERT INTO fonte_fornecedor(fonte_id, fornecedor_id) VALUES (4, 5);
INSERT INTO fonte_fornecedor(fonte_id, fornecedor_id) VALUES (5, 6);
INSERT INTO fonte_fornecedor(fonte_id, fornecedor_id) VALUES (6, 7);
INSERT INTO fonte_fornecedor(fonte_id, fornecedor_id) VALUES (7, 8);
INSERT INTO fonte_fornecedor(fonte_id, fornecedor_id) VALUES (8, 9);
INSERT INTO fonte_fornecedor(fonte_id, fornecedor_id) VALUES (9, 10);
INSERT INTO fonte_fornecedor(fonte_id, fornecedor_id) VALUES (10, 11);
