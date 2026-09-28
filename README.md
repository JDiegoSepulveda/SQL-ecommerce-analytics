# E-Commerce Data Analytics

## Sobre o projeto

Projeto de análise de dados de uma plataforma de e-commerce fictícia, desenvolvido em MariaDB/SQL.

O objetivo foi analisar vendas, clientes, produtos e vendedores, utilizando consultas SQL para responder perguntas de negócio e gerar indicadores relacionados a faturamento, comportamento de compra e concentração de receita.

## Estrutura do banco

Principais entidades:

* `clientes`
* `vendedores`
* `produtos`
* `pedidos`
* `itens_pedido`

A estrutura representa o fluxo de vendas da plataforma, relacionando clientes aos pedidos e os pedidos aos produtos comercializados pelos vendedores.

## Análises realizadas

O projeto contém 6 análises envolvendo:

* Vendas e faturamento
* Clientes
* Produtos
* Vendedores
* Categorias
* Comportamento de compra

### Perguntas analisadas

1. Quais produtos e respectivos vendedores apresentaram maior faturamento e volume de unidades vendidas durante maio de 2026, considerando apenas pedidos pagos?
2. Quais clientes não realizam uma compra paga há pelo menos 90 dias, considerando 01/08/2026 como data de referência, e qual foi seu histórico de faturamento?
3. Qual produto apresentou o maior faturamento dentro de cada categoria e qual foi sua participação no faturamento da respectiva categoria?
4. Como evoluiu o faturamento mensal por categoria e tipo de comércio ao longo de 2026 e qual foi o faturamento acumulado de cada categoria?
5. Como os produtos vendidos em pedidos pagos de 2026 se distribuem em uma Curva ABC baseada no faturamento acumulado?
6. Quais são os cinco clientes com maior faturamento acumulado em 2026, qual é o ticket médio de cada um e em qual categoria concentram o maior gasto?

## Principais resultados

**Vendas**

Em maio de 2026, o produto com maior faturamento entre os pedidos pagos foi o **Monitor Ultrawide 29 Polegadas Full HD**, com R$ 2.819,80 em faturamento e 4 unidades vendidas.

**Clientes inativos**

A análise identificou 9 clientes cuja última compra paga ocorreu há pelo menos 90 dias em relação à data de referência de 01/08/2026. O maior valor histórico gasto entre eles foi de R$ 2.499,00.

**Produtos por categoria**

O **Notebook Gamer Pro 16GB RAM** apresentou R$ 52.804,10 em faturamento e representou 53,07% do faturamento da categoria Eletrônicos e Informática.

**Evolução do faturamento**

O faturamento acumulado de Eletrônicos e Informática chegou a R$ 99.502,70 no período analisado de 2026. As demais categorias também foram acompanhadas mensalmente, considerando os tipos de comércio presentes nos dados.

**Curva ABC**

Os cinco produtos de maior faturamento acumularam 78,38% da receita dos pedidos pagos de 2026. A classificação resultou em produtos nas classes A, B e C conforme o percentual acumulado de faturamento.

**Clientes de maior faturamento**

Camila Gomes Barbosa apresentou o maior faturamento acumulado em 2026, com R$ 14.027,80, ticket médio de R$ 4.675,93 e maior concentração de gasto em Eletrônicos e Informática.

## SQL utilizado

* `INNER JOIN`
* `GROUP BY`
* `HAVING`
* `SUM`, `COUNT` e `MAX`
* CTEs (`WITH`)
* Window Functions
* `ROW_NUMBER()`
* `SUM() OVER()`
* `PARTITION BY`
* análise temporal
* cálculo de ticket médio
* cálculos acumulados
* `COUNT(DISTINCT)`
* classificação por `CASE WHEN`
* Curva ABC
