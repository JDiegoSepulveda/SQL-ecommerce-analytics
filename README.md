# E-Commerce Data Analytics & Business Intelligence

Projeto de análise de dados desenvolvido em **SQL (MariaDB/MySQL)** para simular a operação de uma plataforma de E-Commerce e responder perguntas de negócio relacionadas a vendas, clientes, produtos, vendedores e comportamento de compra.

O projeto foi construído com foco em **raciocínio analítico**, utilizando um banco de dados relacional estruturado, dados transacionais e consultas SQL para transformar dados operacionais em informações úteis para tomada de decisão.

---

## 🎯 Objetivo

Construir uma base de dados relacional capaz de representar uma operação de marketplace e utilizá-la para investigar questões como:

* Quais produtos e vendedores geram maior faturamento?
* Quais clientes estão há mais tempo sem comprar?
* Quais produtos concentram o faturamento de cada categoria?
* Como o faturamento evolui ao longo do tempo?
* Quais produtos concentram a maior parcela da receita?
* Quais clientes apresentam maior valor de compra e qual é seu comportamento de consumo?

O objetivo não é apenas demonstrar conhecimento de sintaxe SQL, mas demonstrar a capacidade de **traduzir perguntas de negócio em consultas analíticas**.

---

## 🛠️ Tecnologias

* **MariaDB 11.8 / SQL**
* Git
* GitHub
* SQL para análise de dados

### Principais conceitos utilizados

* DDL e DML
* Modelagem relacional
* Chaves primárias e estrangeiras
* Integridade referencial
* `CHECK`, `UNIQUE`, `ENUM`
* `INNER JOIN`
* `GROUP BY`
* `HAVING`
* Agregações (`SUM`, `COUNT`, `MAX`)
* CTEs (`WITH`)
* Window Functions
* `ROW_NUMBER()`
* `SUM() OVER()`
* `PARTITION BY`
* Ranking
* Faturamento acumulado
* Análise temporal
* Ticket médio
* Análise de concentração de receita
* Curva ABC por faturamento

---

# 🗄️ Modelo de Dados

O banco foi estruturado em cinco entidades principais:

```text
clientes
    │
    │ 1:N
    ▼
pedidos
    │
    │ 1:N
    ▼
itens_pedido
    │
    │ N:1
    ▼
produtos
    │
    │ N:1
    ▼
vendedores
```

### `clientes`

Armazena informações cadastrais e classificação comercial dos clientes.

Principais atributos:

* `cliente_id`
* `pnome`
* `snome`
* `email`
* `rank_cliente`
* `data_nascimento`
* `data_de_cadastro`

### `vendedores`

Representa os lojistas da plataforma.

Principais atributos:

* `vendedor_id`
* `nome_loja`
* `cnpj`
* `status_loja`
* `categoria`
* `tipo_comercio`

### `produtos`

Catálogo de produtos comercializados pelos vendedores.

Principais atributos:

* `produto_id`
* `vendedor_id`
* `nome_produto`
* `descricao`
* `preco`

### `pedidos`

Representa as transações realizadas pelos clientes.

Principais atributos:

* `pedido_id`
* `cliente_id`
* `status_pedido`
* `valor_total`
* `data_pedido`

### `itens_pedido`

Tabela de detalhamento dos produtos presentes em cada pedido.

Principais atributos:

* `item_id`
* `pedido_id`
* `produto_id`
* `quantidade`
* `preco_unitario`

---

# 📊 Perguntas de Negócio

O projeto contém seis análises principais.

## 1. Desempenho de produtos e vendedores

**Pergunta:**

> Quais produtos e respectivos vendedores geraram maior faturamento e volume de vendas durante maio de 2026, considerando apenas pedidos pagos?

### Técnicas utilizadas

* `INNER JOIN`
* filtros temporais
* agregação
* `SUM()`
* `GROUP BY`
* ordenação por múltiplos critérios

A análise relaciona vendedores, produtos, itens vendidos e pedidos para identificar os produtos com maior geração de receita no período analisado.

---

## 2. Identificação de clientes inativos

**Pergunta:**

> Quais clientes não realizam uma compra paga há pelo menos 90 dias e qual foi seu histórico de faturamento?

### Técnicas utilizadas

* `MAX()`
* `SUM()`
* `GROUP BY`
* `HAVING`
* manipulação de datas

A consulta utiliza a última compra paga de cada cliente como referência para identificar clientes potencialmente elegíveis para ações de reativação.

---

## 3. Produto de maior faturamento por categoria

**Pergunta:**

> Qual produto apresentou o maior faturamento dentro de cada categoria e qual foi sua participação no faturamento da respectiva categoria?

### Técnicas utilizadas

* CTE
* `SUM()`
* `ROW_NUMBER()`
* `PARTITION BY`
* Window Functions
* cálculo de participação percentual

Essa análise demonstra como realizar **ranking dentro de grupos** e comparar o desempenho de um produto com o faturamento total de sua categoria.

---

## 4. Evolução mensal e faturamento acumulado

**Pergunta:**

> Como evoluiu o faturamento mensal por categoria ao longo de 2026 e qual foi o faturamento acumulado de cada categoria?

### Técnicas utilizadas

* agrupamento temporal
* `MONTH()`
* `DATE_FORMAT()`
* CTE
* `SUM() OVER()`
* `PARTITION BY`
* cálculo de acumulado

A análise permite observar a evolução temporal da receita e acompanhar o crescimento acumulado das categorias ao longo do período.

---

## 5. Curva ABC de produtos

**Pergunta:**

> Quais produtos concentram a maior parcela do faturamento da empresa e como eles podem ser classificados segundo uma Curva ABC baseada em receita?

### Critério utilizado

Os produtos são ordenados pelo faturamento e classificados de acordo com o percentual acumulado:

* **Classe A:** até 80% do faturamento acumulado
* **Classe B:** de 80% até 95%
* **Classe C:** acima de 95%

### Técnicas utilizadas

* CTEs
* agregação por produto
* `SUM() OVER()`
* ordenação acumulada
* percentual sobre o faturamento geral
* `CASE WHEN`

A análise pode servir como indicador para apoiar decisões relacionadas à priorização e gestão de estoque.

> **Observação:** a Curva ABC deste projeto é especificamente uma classificação por **faturamento dos produtos vendidos em pedidos pagos em 2026**.

---

## 6. Clientes de maior faturamento, ticket médio e concentração de consumo

**Pergunta:**

> Quais são os cinco clientes com maior faturamento acumulado em 2026, qual é seu ticket médio e em qual categoria concentram o maior gasto?

### Técnicas utilizadas

* múltiplas CTEs
* `COUNT(DISTINCT)`
* `ROW_NUMBER() OVER(PARTITION BY...)`
* agregação por cliente e categoria
* cálculo de ticket médio
* consolidação de métricas

O `COUNT(DISTINCT pedido_id)` é utilizado para evitar que múltiplos itens pertencentes ao mesmo pedido sejam contabilizados como pedidos diferentes.

A análise combina três dimensões:

```text
Valor total comprado
        +
Ticket médio
        +
Categoria de maior gasto
```

permitindo uma visão mais completa do comportamento dos clientes de maior valor.

---

# 🔎 Abordagem Analítica

Uma característica central deste projeto é a separação entre **dado operacional** e **métrica analítica**.

Por exemplo, para calcular o ticket médio, não basta somar os itens vendidos. É necessário compreender a estrutura:

```text
Cliente
   ↓
Pedido
   ↓
Itens do pedido
```

Um único pedido pode possuir diversos itens.

Por isso:

```sql
COUNT(DISTINCT pedido_id)
```

é necessário para obter a quantidade real de pedidos e evitar distorção do ticket médio.

Esse tipo de cuidado aparece ao longo das consultas, especialmente nas análises envolvendo pedidos e seus respectivos itens.

---

# 📁 Estrutura do Projeto

```text
SQL-ecommerce-analytics/
│
├── README.md
│
├── sql/
│   ├── 01_ddl_schema.sql
│   ├── 02_dml_data.sql
│   └── 03_analytics_queries.sql
│
└── .gitignore
```

### `01_ddl_schema.sql`

Criação do banco de dados, tabelas, relacionamentos, constraints e regras de integridade.

### `02_dml_data.sql`

Carga dos dados utilizados nas análises.

### `03_analytics_queries.sql`

Consultas analíticas desenvolvidas para responder às seis perguntas de negócio.

---

# 🧠 Competências Demonstradas

Este projeto demonstra experiência prática com:

### Banco de Dados

* modelagem relacional
* relacionamentos 1:N e N:1
* chaves primárias e estrangeiras
* integridade referencial
* constraints
* organização de dados transacionais

### SQL

* consultas com múltiplos `JOINs`
* agregações
* CTEs
* Window Functions
* ranking
* análise temporal
* métricas acumuladas
* classificação condicional
* tratamento de granularidade
* cálculo de métricas derivadas

### Análise de Dados

* faturamento
* ticket médio
* concentração de receita
* comportamento de clientes
* inatividade
* desempenho de produtos
* análise por categoria
* análise temporal
* Curva ABC

### Raciocínio Analítico

Mais do que demonstrar funções SQL isoladas, o projeto busca demonstrar o fluxo:

```text
Pergunta de negócio
        ↓
Definição da métrica
        ↓
Identificação das tabelas necessárias
        ↓
Relacionamento dos dados
        ↓
Agregação / transformação
        ↓
Análise
        ↓
Interpretação do resultado
```

---

# 🚀 Como Executar

### 1. Clone o repositório

```bash
git clone https://github.com/JDiegoSepulveda/SQL-ecommerce-analytics.git
cd SQL-ecommerce-analytics
```

### 2. Crie o banco e as tabelas

Execute:

```text
sql/01_ddl_schema.sql
```

### 3. Popule o banco

Execute:

```text
sql/02_dml_data.sql
```

### 4. Execute as análises

Execute:

```text
sql/03_analytics_queries.sql
```

---

# 📌 Próximos Passos

Possíveis extensões futuras do projeto:

* criação de índices orientados às consultas analíticas;
* análise de planos de execução com `EXPLAIN`;
* investigação de qualidade e consistência dos dados;
* criação de views para métricas recorrentes;
* integração das consultas com Python;
* construção de dashboards para apresentação dos indicadores.

---

## 👤 Autor

**Juan Diego de Paula Sepulveda**

Projeto desenvolvido como parte da construção de portfólio prático em **SQL, Banco de Dados e Análise de Dados**.

[GitHub](https://github.com/JDiegoSepulveda)
