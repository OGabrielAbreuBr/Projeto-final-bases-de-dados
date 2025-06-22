-- --------------------------------------------------
-- Projeto final de Bases de Dados

    -- Integrantes:
    -- Antônio Carlos de Almeida Micheli Neto - 14559013
    -- Gabriel de Andrade Abreu - 14571362
    -- Guilherme Antônio Costa Bandeira - 14575620
    -- Julia Cavallio Orlando - 14758721

-- --------------------------------------------------

-- SQL feito com base no Modelo Relacional Normalizado em BCNF

-- --------------------------------------------------

COMMIT;

DROP TABLE IF EXISTS Matricula_disciplina CASCADE;
DROP TABLE IF EXISTS Estar_na_Ementa CASCADE;
DROP TABLE IF EXISTS Ministrar_aula CASCADE;
DROP TABLE IF EXISTS Pre_requisito_discilina CASCADE;
DROP TABLE IF EXISTS Pre_requisito_curso CASCADE;
DROP TABLE IF EXISTS curso_infraestrutura CASCADE;
DROP TABLE IF EXISTS curso_regra CASCADE;
DROP TABLE IF EXISTS Disciplina_Material_basico CASCADE;
DROP TABLE IF EXISTS Professor_especializacao CASCADE;
DROP TABLE IF EXISTS Mensagem CASCADE;
DROP TABLE IF EXISTS Aviso CASCADE;
DROP TABLE IF EXISTS Avaliacao CASCADE;
DROP TABLE IF EXISTS Feedback CASCADE;
DROP TABLE IF EXISTS Matricula CASCADE;
DROP TABLE IF EXISTS Capacidade_Turma CASCADE;
DROP TABLE IF EXISTS Turma CASCADE;
DROP TABLE IF EXISTS Departamento_curso CASCADE;
DROP TABLE IF EXISTS Chefe_departamento CASCADE;
DROP TABLE IF EXISTS Funcionario_Administrativo CASCADE;
DROP TABLE IF EXISTS Professor CASCADE;
DROP TABLE IF EXISTS Aluno CASCADE;
DROP TABLE IF EXISTS Usuario CASCADE;
DROP TABLE IF EXISTS Disciplina CASCADE;
DROP TABLE IF EXISTS Curso CASCADE;
DROP TABLE IF EXISTS Departamento CASCADE;
DROP TABLE IF EXISTS Sala_de_Aula CASCADE;
DROP TABLE IF EXISTS Predio CASCADE;
DROP TABLE IF EXISTS Unidade_escolar CASCADE;
DROP TABLE IF EXISTS Campus CASCADE;

-- RELAÇÕES DE LOCALIZAÇÃO

CREATE TABLE Campus (
    ID_Campus           SERIAL        PRIMARY KEY,
    Nome_Campus         VARCHAR(100)  NOT NULL UNIQUE, -- chave candidata
    Pais                VARCHAR(100),
    Estado              VARCHAR(100),
    Cidade              VARCHAR(100),
    Bairro              VARCHAR(100),
    Rua                 VARCHAR(100),
    Numero_endereco     INTEGER
);

CREATE TABLE Unidade_escolar (
    ID_Unidade       SERIAL        PRIMARY KEY,
    Nome_Unidade     VARCHAR(100)  NOT NULL,
    ID_Campus        INTEGER       NOT NULL,

    CONSTRAINT UQ_Unidade_Campus_Nome 
        UNIQUE (ID_Campus, Nome_Unidade),
    -- Nome unidadde e id campus são chaves candidatas juntas

    FOREIGN KEY (ID_Campus) 
        REFERENCES Campus(ID_Campus)
);

CREATE TABLE Predio (
    Nome_predio         VARCHAR(100)  NOT NULL,
    ID_Unidade          INTEGER       NOT NULL,

    PRIMARY KEY (Nome_predio, ID_Unidade),
    FOREIGN KEY (ID_Unidade) REFERENCES Unidade_escolar(ID_Unidade)
);

CREATE TABLE Sala_de_Aula (
    ID_Unidade          INTEGER       NOT NULL,
    Nome_predio         VARCHAR(100)  NOT NULL,
    Andar_sala          INTEGER       NOT NULL,
    Numero_sala         INTEGER       NOT NULL,
    Capacidade_sala     INTEGER,

    PRIMARY KEY (ID_Unidade, Nome_predio, Andar_sala, Numero_sala),

    FOREIGN KEY (ID_Unidade, Nome_predio)
        REFERENCES Predio(Nome_predio, ID_Unidade)
);

-- RELAÇÕES ACADÊMICA

CREATE TABLE Departamento (
    ID_Departamento     SERIAL        PRIMARY KEY,
    Nome_departamento   VARCHAR(100)  NOT NULL
);
CREATE TABLE Curso (
    ID_Curso            SERIAL        PRIMARY KEY,
    nome_Curso          VARCHAR(100)  NOT NULL,
    carga_horaria       INTEGER,
    Nivel_de_Ensino     VARCHAR(20)
        CHECK (Nivel_de_Ensino IN ('Básico','Fundamental','Médio','Superior')),
    Num_vagas           INTEGER,
    Ementa              TEXT,
    Nome_predio         VARCHAR(100)  NOT NULL,
    ID_Unidade          INTEGER       NOT NULL,
    Andar_sala          INTEGER       NOT NULL,
    Numero_sala         INTEGER       NOT NULL,

    -- FK: vínculo com Predio.
    -- Garante que o prédio informado exista em Predio.
    -- Predio.PK = (Nome_predio, ID_Unidade), portanto:
    FOREIGN KEY (Nome_predio, ID_Unidade)
        REFERENCES Predio (Nome_predio, ID_Unidade),

    -- FK: vínculo com Sala_de_Aula.
    -- Assegura que a sala (prédio + unidade + andar + número) esteja cadastrada.
    -- Sala_de_Aula.PK = (ID_Unidade, Nome_predio, Andar_sala, Numero_sala), portanto:
    FOREIGN KEY (ID_Unidade, Nome_predio, Andar_sala, Numero_sala)
        REFERENCES Sala_de_Aula (
            ID_Unidade,
            Nome_predio,
            Andar_sala,
            Numero_sala
        )
);


CREATE TABLE Departamento_curso (
    ID_Curso            INTEGER       NOT NULL,
    ID_Departamento     INTEGER       NOT NULL,

    PRIMARY KEY (ID_Curso, ID_Departamento),
    FOREIGN KEY (ID_Curso) REFERENCES Curso(ID_Curso),
    FOREIGN KEY (ID_Departamento) REFERENCES Departamento(ID_Departamento)
);

CREATE TABLE Disciplina (
    ID_disciplina       SERIAL        PRIMARY KEY,
    Nome_Disciplina     VARCHAR(100)  NOT NULL,
    Aulas_semanais      INTEGER,
    Preco_base          DECIMAL(10,2),
    Nome_predio         VARCHAR(100)  NOT NULL,
    ID_Unidade          INTEGER       NOT NULL,

    FOREIGN KEY (Nome_predio, ID_Unidade)
        REFERENCES Predio(Nome_predio, ID_Unidade)
);

CREATE TABLE Turma (
    Codigo_turma        SERIAL        PRIMARY KEY,
    ID_disciplina       INTEGER       NOT NULL,
    Nome_turma          VARCHAR(100),
    ano_letivo          INTEGER,
    Semestre_letivo     INTEGER,
    data_limite_aceite  TIMESTAMP,
    capacidade_turma    INTEGER,
    ID_Unidade          INTEGER       NOT NULL,
    Nome_predio         VARCHAR(100)  NOT NULL,
    Andar_sala          INTEGER       NOT NULL,
    Numero_sala         INTEGER       NOT NULL,

    FOREIGN KEY (ID_disciplina)
        REFERENCES Disciplina(ID_disciplina),
    FOREIGN KEY (ID_Unidade) REFERENCES Unidade_escolar(ID_Unidade),
    FOREIGN KEY (Nome_predio, ID_Unidade)
        REFERENCES Predio(Nome_predio, ID_Unidade),
    FOREIGN KEY (ID_Unidade, Nome_predio, Andar_sala, Numero_sala)
        REFERENCES Sala_de_Aula(ID_Unidade, Nome_predio, Andar_sala, Numero_sala)
);

CREATE TABLE Capacidade_Turma (
    Codigo_turma        INTEGER       NOT NULL,
    Capacidade          INTEGER,
    PRIMARY KEY (Codigo_turma),
    FOREIGN KEY (Codigo_turma)
        REFERENCES Turma(Codigo_turma)
);

-- RELAÇÕES DE USUÁRIOS

CREATE TABLE Usuario (
    ID_usuario          SERIAL        PRIMARY KEY,
    Nome                VARCHAR(100)  NOT NULL,
    Sobrenome           VARCHAR(100)  NOT NULL,
    Numero_telefone     VARCHAR(20)   NOT NULL,
    Sexo                VARCHAR(20)
        CHECK (Sexo IN ('Masculino','Feminino','Outro','Não-Informar')),
    Email               VARCHAR(100),
    senha               VARCHAR(100),
    Estado              VARCHAR(100),
    Cidade              VARCHAR(100),
    Bairro              VARCHAR(100),
    Rua                 VARCHAR(100),
    Numero_endereco     VARCHAR(20),
    Ano_nascimento      INTEGER,
    Mes_nascimento      INTEGER,
    Dia_nascimento      INTEGER,

    -- chave candidata composta
    CONSTRAINT UQ_Usuario_Candidato
        UNIQUE (Nome, Sobrenome, Numero_telefone)
);


CREATE TABLE Aluno (
    ID_usuario          INTEGER       PRIMARY KEY,
    Nome_predio         VARCHAR(100)  NOT NULL,
    ID_Unidade          INTEGER       NOT NULL,
    FOREIGN KEY (ID_usuario)
        REFERENCES Usuario(ID_usuario),
    FOREIGN KEY (Nome_predio, ID_Unidade)
        REFERENCES Predio(Nome_predio, ID_Unidade)
);

CREATE TABLE Professor (
    ID_usuario          INTEGER       PRIMARY KEY,
    Titulacao           VARCHAR(50)
        CHECK (Titulacao IN ('Doutor','Associado','Livre-docência')),
    ChefeSN             BOOLEAN,
    Nome_predio         VARCHAR(100)  NOT NULL,
    ID_Unidade          INTEGER       NOT NULL,

    FOREIGN KEY (ID_usuario)
        REFERENCES Usuario(ID_usuario),
    FOREIGN KEY (Nome_predio, ID_Unidade)
        REFERENCES Predio(Nome_predio, ID_Unidade)
);

CREATE TABLE Funcionario_Administrativo (
    ID_funcionario      INTEGER       PRIMARY KEY,

    FOREIGN KEY (ID_funcionario)
        REFERENCES Usuario(ID_usuario)
);

-- CHEFE DE DEPARTAMENTO 
CREATE TABLE Chefe_departamento (
    ID_Chefe            INTEGER       NOT NULL,
    ID_Departamento     INTEGER       NOT NULL,

    PRIMARY KEY (ID_Chefe, ID_Departamento),
    FOREIGN KEY (ID_Chefe)
        REFERENCES Professor(ID_usuario),
    FOREIGN KEY (ID_Departamento)
        REFERENCES Departamento(ID_Departamento)
);


-- RELAÇÕES DE AGREGAÇÃO

CREATE TABLE Matricula (
    ID_Matricula        SERIAL        PRIMARY KEY,
    data_matricula      TIMESTAMP     NOT NULL,
    ID_aluno            INTEGER       NOT NULL,
    Codigo_turma        INTEGER       NOT NULL,
    Status              VARCHAR(20)
        CHECK (Status IN (
          'Ativa','Trancada','Concluida','Reprovada','Cancelada','Aceita'
        )),
    Desconto            FLOAT,
    ID_professor        INTEGER,
    data_aceite         TIMESTAMP,
    FOREIGN KEY (ID_aluno)
        REFERENCES Aluno(ID_usuario),
    FOREIGN KEY (Codigo_turma)
        REFERENCES Turma(Codigo_turma),
    FOREIGN KEY (ID_professor)
        REFERENCES Professor(ID_usuario),

    -- chave candidata composta
    CONSTRAINT UQ_Matricula_Candidato
      UNIQUE (data_matricula, ID_aluno, Codigo_turma)
);


CREATE TABLE Matricula_disciplina (
    ID_Matricula        INTEGER       NOT NULL,
    ID_disciplina       INTEGER       NOT NULL,

    PRIMARY KEY (ID_Matricula, ID_disciplina),
    FOREIGN KEY (ID_Matricula)
        REFERENCES Matricula(ID_Matricula),
    FOREIGN KEY (ID_disciplina)
        REFERENCES Disciplina(ID_disciplina)
);

CREATE TABLE Feedback (
    ID_feedback         SERIAL        PRIMARY KEY,
    ID_remetente        INTEGER       NOT NULL,
    ID_destinatario     INTEGER       NOT NULL,
    ID_disciplina       INTEGER       NOT NULL,
    Ano_letivo          INTEGER       NOT NULL,
    Semestre_letivo     INTEGER       NOT NULL,
    Comentario          TEXT,
    Material_de_Apoio   INTEGER,
    Relevancia_do_Conteudo INTEGER,
    Infraestrutura_da_Sala INTEGER,
    Didatica            INTEGER,

    FOREIGN KEY (ID_remetente)
        REFERENCES Aluno(ID_usuario),
    FOREIGN KEY (ID_destinatario)
        REFERENCES Professor(ID_usuario),
    FOREIGN KEY (ID_disciplina)
        REFERENCES Disciplina(ID_disciplina)
);

CREATE TABLE Avaliacao (
    ID_matricula        INTEGER       NOT NULL,
    tipo_avaliacao      VARCHAR(50)   NOT NULL,
    Nota                INTEGER,
    PRIMARY KEY (ID_matricula, tipo_avaliacao),
    FOREIGN KEY (ID_matricula)
        REFERENCES Matricula(ID_Matricula)
);

CREATE TABLE Aviso (
    ID_Aviso            SERIAL        PRIMARY KEY,
    ID_remetente        INTEGER       NOT NULL,
    ID_destinatario     INTEGER       NOT NULL,
    data_envio          TIMESTAMP     NOT NULL,
    Texto               TEXT,

    FOREIGN KEY (ID_remetente)
        REFERENCES Funcionario_Administrativo(ID_funcionario),
    FOREIGN KEY (ID_destinatario)
        REFERENCES Usuario(ID_usuario)
);

CREATE TABLE Mensagem (
    ID_mensagem         SERIAL        PRIMARY KEY,
    ID_remetente        INTEGER       NOT NULL,
    ID_destinatario     INTEGER       NOT NULL,
    data_envio          TIMESTAMP     NOT NULL,
    Texto               TEXT,

    FOREIGN KEY (ID_remetente)
        REFERENCES Usuario(ID_usuario),
    FOREIGN KEY (ID_destinatario)
        REFERENCES Usuario(ID_usuario)
);


-- ATRIBUTOS MULTIVALORADOS

CREATE TABLE curso_infraestrutura (
    ID_curso            INTEGER       NOT NULL,
    Infraestrutura      VARCHAR(100)  NOT NULL,

    PRIMARY KEY (ID_curso, Infraestrutura),
    FOREIGN KEY (ID_curso)
        REFERENCES Curso(ID_Curso)
);

CREATE TABLE curso_regra (
    ID_curso            INTEGER       NOT NULL,
    Regra               VARCHAR(100)  NOT NULL,

    PRIMARY KEY (ID_curso, Regra),
    FOREIGN KEY (ID_curso)
        REFERENCES Curso(ID_Curso)
);

CREATE TABLE Disciplina_Material_basico (
    ID_disciplina       INTEGER       NOT NULL,
    Material_basico     VARCHAR(100)  NOT NULL,

    PRIMARY KEY (ID_disciplina, Material_basico),
    FOREIGN KEY (ID_disciplina)
        REFERENCES Disciplina(ID_disciplina)
);

CREATE TABLE Professor_especializacao (
    ID_professor        INTEGER       NOT NULL,
    Especializacao      VARCHAR(100)  NOT NULL,

    PRIMARY KEY (ID_professor, Especializacao),
    FOREIGN KEY (ID_professor)
        REFERENCES Professor(ID_usuario)
);

-- RELACIONAMENTOS M:N

CREATE TABLE Estar_na_Ementa (
    ID_curso            INTEGER       NOT NULL,
    ID_disciplina       INTEGER       NOT NULL,

    PRIMARY KEY (ID_curso, ID_disciplina),
    FOREIGN KEY (ID_curso)
        REFERENCES Curso(ID_Curso),
    FOREIGN KEY (ID_disciplina)
        REFERENCES Disciplina(ID_disciplina)
);

CREATE TABLE Ministrar_aula (
    ID_professor        INTEGER       NOT NULL,
    ID_disciplina       INTEGER       NOT NULL,

    PRIMARY KEY (ID_professor, ID_disciplina),
    FOREIGN KEY (ID_professor)
        REFERENCES Professor(ID_usuario),
    FOREIGN KEY (ID_disciplina)
        REFERENCES Disciplina(ID_disciplina)
);

CREATE TABLE Pre_requisito_curso (
    ID_curso_requerente     INTEGER   NOT NULL,
    ID_curso_requisitado    INTEGER   NOT NULL,

    PRIMARY KEY (ID_curso_requerente, ID_curso_requisitado),
    FOREIGN KEY (ID_curso_requerente)
        REFERENCES Curso(ID_Curso),
    FOREIGN KEY (ID_curso_requisitado)
        REFERENCES Curso(ID_Curso)
);

CREATE TABLE Pre_requisito_discilina (
    ID_curso_requerente     INTEGER   NOT NULL,
    ID_disciplina_requisitada INTEGER  NOT NULL,

    PRIMARY KEY (ID_curso_requerente, ID_disciplina_requisitada),
    FOREIGN KEY (ID_curso_requerente)
        REFERENCES Curso(ID_Curso),
    FOREIGN KEY (ID_disciplina_requisitada)
        REFERENCES Disciplina(ID_disciplina)
);
