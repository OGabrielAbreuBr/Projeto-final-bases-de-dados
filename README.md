# Projeto Final de Base de Dados

## Descrição
> Este projeto implementa um banco de dados relacional para gerenciar um sistema online para gerenciar suas atividades acadêmicas
e administrativas, facilitando a interação entre alunos, professores e a administração. Inclui scripts de criação de esquema, carga de dados de exemplo e consultas SQL para análise de desempenho e relatórios.

## Pré-requisitos - configuração do banco de dados
Coisas que precisam ser instaladas antes de executar o projeto:
- [ ] **PostgreSQL** (inclui `psql`)  
- [ ] **Python 3.8+** e **pip**  
- [ ] **Git**

Depois, instale as dependências do projeto (caso não tenha ainda o postgre):

    
    pip install -r requirements.txt
 
## Estrutura do Repositório
  Principais arquivos e diretórios:

    /
    ├── scripts/
    |   ├── requirements.txt
    │   ├── setup.sql
    │   ├── insertion.sql
    │   ├── consultas/
    │   │   ├── cons1.sql
    │   │   ├── cons2.sql
    │   │   └── ...
    |   ├── index/
    |   |    ├── index1.sql
    |   |    └── ...
    │   └── visions/
    |        ├── vision1.sql
    |        └── ...
    |          
    ├── README.md
    └── LICENSE


- `scripts/setup.sql` – cria tabelas e constraints.  
- `scripts/insertion.sql` – insere dados de exemplo.  
- `scripts/consultas/` – contém todas as consultas exigidas no enunciado.

## Execução do banco de dados
1. **Clonar repositório**  
   ```bash
   git clone https://github.com/OGabrielAbreuBr/Projeto-final-bases-de-dados.git
   cd Projeto-final-bases-de-dados
2. **Criar o banco de dados**
    ```bash
    sudo -u postgres psql -f setup.sql
3. **Carregar dados de exemplo**
    ```bash
    sudo -u postgres psql -d trabalho_bd -f scripts/insertion.sql
    
## Execução das consultas
    
    sudo -u postgres psql -d trabalho_bd -f scripts/consultas/cons1.sql
    sudo -u postgres psql -d trabalho_bd -f scripts/consultas/cons2.sql
    
    #Tem até 7 consultas, é só colocar em scripts/consultas/cons[numero_consulta].sql

## Resultados Esperados das consultas
- **Consulta 1:** Lista cursos e departamentos da Escola de Engenharia.  
- **Consulta 2:** Encontra professores que lecionam mais de uma disciplina.
- **Consulta 3:** Calcula a média geral de notas para cada curso.
- **Consulta 4:** Lista alunos de Ciência da Computação na disciplina de Banco de Dados.
- **Consulta 5:** Compara a capacidade da turma com o número de alunos matriculados.
- **Consulta 6:** Verifica os alunos que passaram em Cálculo
- **Consulta 7:** Calcula a média de feedback em didática para cada professor.

## Equipe do Projeto
- **Julia Cavallio Orlando** (NUSP: 14758721) — GitHub: [@JuliaOrlando](https://github.com/JuliaOrlando)
- **Antônio C. de A. M. Neto** (NUSP: 14559013) — GitHub: [@Antonioonet](https://github.com/Antonioonet)  
- **Gabriel de Andrade Abreu** (NUSP: 14571362) — GitHub: [@OGabrielAbreuBr](https://github.com/OGabrielAbreuBr)
- **Guilherme Antonio Costa Bandeira** (NUSP: 14575620) — GitHub: [@Guilherme-Bandeira](https://github.com/Guilherme-Bandeira) 

## Agradecimentos
Agradecemos a todos que contribuíram para o desenvolvimento deste projeto, em especial:  
- Prof. Mirela, pelo suporte e orientação.  
- Colegas de turma e grupo de trabalho.  


