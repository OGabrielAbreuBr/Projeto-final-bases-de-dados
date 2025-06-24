# Projeto Final de Base de Dados

## Descrição
> Este projeto implementa um banco de dados relacional para gerenciar um sistema online para gerenciar suas atividades acadêmicas
e administrativas, facilitando a interação entre alunos, professores e a administração. Inclui scripts de criação de esquema, carga de dados de exemplo e consultas SQL para análise de desempenho e relatórios.

## Pré-requisitos
Coisas que precisam ser instaladas antes de executar o projeto:
- [ ] SGBD - PostgreSQL 
- [ ] Cliente de linha de comando (ex.:`psql`)
- [ ] Linguagem Python
- [ ] Outros (por exemplo, `git`, `Docker`)

## Estrutura do Repositório
Principais arquivos e diretórios:
├── scripts/
│ ├── 01_create_schema.sql
│ ├── 02_load_data.sql
│ ├── 03_consultas/
│ │ ├── consulta1.sql
│ │ ├── consulta2.sql
│ │ └── ...
│ └── ...
├── README.md
└── LICENSE

- `scripts/01_create_schema.sql` – cria tabelas, índices e constraints.  
- `scripts/02_load_data.sql` – insere dados de exemplo.  
- `scripts/03_consultas/` – contém todas as consultas exigidas no enunciado.

## Como Executar
1. **Clonar repositório**  
   ```bash
   git clone https://github.com/SEU_USUARIO/SEU_REPOSITORIO.git
   cd SEU_REPOSITORIO
2. **Criar o banco de dados**
    ```bash
    psql -U usuario -f scripts/01_create_schema.sql
3. **Carregar dados de exemplo**
    ```bash
    psql -U usuario -d nome_do_banco -f scripts/02_load_data.sql
4. **Executar consultas**
    ```bash
    psql -U usuario -d nome_do_banco -f scripts/03_consultas/consulta1.sql
    psql -U usuario -d nome_do_banco -f scripts/03_consultas/consulta2.sql

## Resultados Esperados
- **Consulta 1:** lista dos 10 clientes com maior número de pedidos.  
- **Consulta 2:** total de vendas por produto no último trimestre.  
  _*(adicione descrições para cada consulta)*_

## Equipe do Projeto
- **Julia Cavallio Orlando** (NUSP: 14758721) — GitHub: [@usuario1](https://github.com/usuario1)
- **Antônio C. de A. M. Neto** (NUSP: 14559013) — GitHub: [@usuario2](https://github.com/usuario2)  
- **Gabriel de Andrade Abreu** (NUSP: 14571362) — GitHub: [@usuario3](https://github.com/usuario3)
- **Guilherme Antonio Costa Bandeira** (NUSP: 14575620) — GitHub: [@usuario3](https://github.com/usuario3) 

## Agradecimentos
Agradecemos a todos que contribuíram para o desenvolvimento deste projeto, em especial:  
- Prof. Mirela, pelo suporte e orientação.  
- Colegas de turma e grupo de estudo.  


