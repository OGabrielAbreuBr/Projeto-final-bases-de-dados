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
        REFERENCES Predio(ID_Unidade,Nome_predio)
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

-- Tabela: Campus (2 registros)
-- Descrição: Mantém os dois campi para separar as áreas de conhecimento.
INSERT INTO Campus (ID_Campus, Nome_Campus, Pais, Estado, Cidade, Bairro, Rua, Numero_endereco) VALUES
(1, 'Campus Tecnológico de São Carlos', 'Brasil', 'São Paulo', 'São Carlos', 'Jardim Lutfalla', 'Rua da Tecnologia', 1000),
(2, 'Campus de Humanidades de Araraquara', 'Brasil', 'São Paulo', 'Araraquara', 'Vila Harmonia', 'Alameda das Letras', 500);

-- Tabela: Unidade_escolar (3 registros)
-- Descrição: Unidades acadêmicas específicas para cada área.
INSERT INTO Unidade_escolar (ID_Unidade, Nome_Unidade, ID_Campus) VALUES
(1, 'Instituto de Computação e Exatas', 1),
(2, 'Faculdade de Letras e Ciências Sociais', 2),
(3, 'Escola de Engenharia', 1);

-- Tabela: Predio (5 registros)
-- Descrição: Prédios agora associados às unidades escolares mais específicas.
INSERT INTO Predio (Nome_predio, ID_Unidade) VALUES
('Bloco de Computação', 1),
('Prédio de Ciências Básicas', 1),
('Prédio de Engenharia', 3),
('Prédio de Letras e Artes', 2),
('Prédio de Ciências Humanas', 2);

-- Tabela: Sala_de_Aula (12 registros)
-- Descrição: Salas de aula distribuídas nos prédios corretos.
INSERT INTO Sala_de_Aula (ID_Unidade, Nome_predio, Andar_sala, Numero_sala, Capacidade_sala) VALUES
-- Prédios da Unidade 1 (Computação e Exatas)
(1, 'Bloco de Computação', 1, 101, 50),
(1, 'Bloco de Computação', 2, 201, 30),
(1, 'Prédio de Ciências Básicas', 1, 101, 80),
(1, 'Prédio de Ciências Básicas', 1, 102, 80),
-- Prédios da Unidade 3 (Engenharia)
(3, 'Prédio de Engenharia', 1, 101, 60),
(3, 'Prédio de Engenharia', 2, 201, 40),
-- Prédios da Unidade 2 (Humanidades)
(2, 'Prédio de Letras e Artes', 1, 101, 40),
(2, 'Prédio de Letras e Artes', 2, 201, 40),
(2, 'Prédio de Ciências Humanas', 1, 101, 60),
(2, 'Prédio de Ciências Humanas', 1, 102, 60),
(2, 'Prédio de Ciências Humanas', 2, 201, 30);


-- Tabela: Departamento (4 registros)
INSERT INTO Departamento (ID_Departamento, Nome_departamento) VALUES
(1, 'Departamento de Computação'),
(2, 'Departamento de Engenharia'),
(3, 'Departamento de Letras'),
(4, 'Departamento de Filosofia');

-- Tabela: Curso (4 registros)
INSERT INTO Curso (ID_Curso, nome_Curso, carga_horaria, Nivel_de_Ensino, Num_vagas, Ementa, Nome_predio, ID_Unidade, Andar_sala, Numero_sala) VALUES
(1, 'Ciência da Computação', 3200, 'Superior', 40, 'Ementa...', 'Bloco de Computação', 1, 1, 101),
(2, 'Engenharia de Produção', 3600, 'Superior', 40, 'Ementa...', 'Prédio de Engenharia', 3, 1, 101),
(3, 'Letras', 2600, 'Superior', 50, 'Ementa...', 'Prédio de Letras e Artes', 2, 1, 101),
(4, 'Filosofia', 2400, 'Superior', 50, 'Ementa...', 'Prédio de Ciências Humanas', 2, 1, 101);

-- Tabela: Departamento_curso (4 registros)
INSERT INTO Departamento_curso (ID_Curso, ID_Departamento) VALUES
(1, 1), (2, 2), (3, 3), (4, 4);

-- Tabela: Disciplina (12 registros)
INSERT INTO Disciplina (ID_disciplina, Nome_Disciplina, Aulas_semanais, Preco_base, Nome_predio, ID_Unidade) VALUES
(1, 'Cálculo I', 6, 500.00, 'Prédio de Ciências Básicas', 1),
(2, 'Introdução à Programação', 4, 600.00, 'Bloco de Computação', 1),
(3, 'Estruturas de Dados', 4, 650.00, 'Bloco de Computação', 1),
(4, 'Física Geral', 4, 550.00, 'Prédio de Ciências Básicas', 1),
(5, 'Pesquisa Operacional', 4, 680.00, 'Prédio de Engenharia', 3),
(6, 'Banco de Dados', 4, 700.00, 'Bloco de Computação', 1),
(7, 'Teoria Literária', 2, 300.00, 'Prédio de Letras e Artes', 2),
(8, 'Linguística I', 2, 320.00, 'Prédio de Letras e Artes', 2),
(9, 'Introdução à Filosofia', 2, 350.00, 'Prédio de Ciências Humanas', 2),
(10, 'Lógica I', 4, 380.00, 'Prédio de Ciências Humanas', 2),
(11, 'Ética', 2, 360.00, 'Prédio de Ciências Humanas', 2),
(12, 'Literatura Brasileira', 4, 400.00, 'Prédio de Letras e Artes', 2);

-- Tabela: Estar_na_Ementa (Curso x Disciplina)
INSERT INTO Estar_na_Ementa (ID_curso, ID_disciplina) VALUES
(1, 1), (1, 2), (1, 3), (1, 6), (2, 1), (2, 4), (2, 5), (3, 7), (3, 8), (3, 12), (4, 9), (4, 10), (4, 11);

-- Tabela: Usuario (40 registros)
INSERT INTO Usuario (ID_usuario, Nome, Sobrenome, Numero_telefone, Sexo, Email, senha, Ano_nascimento, Mes_nascimento, Dia_nascimento) VALUES
-- Alunos (1-20)
(1, 'Ana', 'Souza', '16991000001', 'Feminino', 'ana.s@email.com', 'senha123', 2003, 5, 15), (2, 'Bruno', 'Gomes', '16991000002', 'Masculino', 'bruno.g@email.com', 'senha123', 2004, 8, 20), (3, 'Carla', 'Lima', '16991000003', 'Feminino', 'carla.l@email.com', 'senha123', 2003, 2, 10), (4, 'Daniel', 'Pereira', '16991000004', 'Masculino', 'daniel.p@email.com', 'senha123', 2002, 11, 30), (5, 'Eduarda', 'Alves', '16991000005', 'Feminino', 'eduarda.a@email.com', 'senha123', 2004, 1, 25), (6, 'Fernanda', 'Ribeiro', '16991000006', 'Feminino', 'fernanda.r@email.com', 'senha123', 2003, 7, 12), (7, 'Gabriel', 'Martins', '16991000007', 'Masculino', 'gabriel.m@email.com', 'senha123', 2004, 3, 5), (8, 'Helena', 'Barros', '16991000008', 'Feminino', 'helena.b@email.com', 'senha123', 2003, 9, 18), (9, 'Igor', 'Melo', '16991000009', 'Masculino', 'igor.m@email.com', 'senha123', 2002, 12, 1), (10, 'Julia', 'Castro', '16991000010', 'Feminino', 'julia.c@email.com', 'senha123', 2004, 4, 22), (11, 'Laura', 'Pinto', '16991000011', 'Feminino', 'laura.p@email.com', 'senha123', 2003, 6, 3), (12, 'Marcos', 'Freitas', '16991000012', 'Masculino', 'marcos.f@email.com', 'senha123', 2002, 10, 14), (13, 'Nina', 'Nogueira', '16991000013', 'Feminino', 'nina.n@email.com', 'senha123', 2004, 5, 29), (14, 'Otavio', 'Cardoso', '16991000014', 'Masculino', 'otavio.c@email.com', 'senha123', 2003, 8, 8), (15, 'Paula', 'Rocha', '16991000015', 'Feminino', 'paula.r@email.com', 'senha123', 2002, 1, 19), (16, 'Rafael', 'Santos', '16991000016', 'Masculino', 'rafael.s@email.com', 'senha123', 2004, 2, 28), (17, 'Sofia', 'Teixeira', '16991000017', 'Feminino', 'sofia.t@email.com', 'senha123', 2003, 11, 7), (18, 'Thiago', 'Correia', '16991000018', 'Masculino', 'thiago.c@email.com', 'senha123', 2002, 7, 21), (19, 'Ursula', 'Dias', '16991000019', 'Feminino', 'ursula.d@email.com', 'senha123', 2004, 9, 13), (20, 'Vitor', 'Azevedo', '16991000020', 'Masculino', 'vitor.a@email.com', 'senha123', 2003, 12, 24),
-- Professores (21-35)
(21, 'Carlos', 'Andrade', '16992000021', 'Masculino', 'carlos.a@email.com', 'senhaforte', 1970, 1, 5), (22, 'Beatriz', 'Mendes', '16992000022', 'Feminino', 'beatriz.m@email.com', 'senhaforte', 1980, 7, 25), (23, 'Eduardo', 'Ferreira', '16992000023', 'Masculino', 'eduardo.f@email.com', 'senhaforte', 1965, 3, 12), (24, 'Debora', 'Campos', '16992000024', 'Feminino', 'debora.c@email.com', 'senhaforte', 1982, 5, 19), (25, 'Fabio', 'Nascimento', '16992000025', 'Masculino', 'fabio.n@email.com', 'senhaforte', 1975, 10, 30), (26, 'Gloria', 'Pires', '16992000026', 'Feminino', 'gloria.p@email.com', 'senhaforte', 1968, 8, 14), (27, 'Heitor', 'Villa-Lobos', '16992000027', 'Masculino', 'heitor.v@email.com', 'senhaforte', 1972, 4, 2), (28, 'Iris', 'Abravanel', '16992000028', 'Feminino', 'iris.a@email.com', 'senhaforte', 1979, 11, 26), (29, 'Joaquim', 'Barbosa', '16992000029', 'Masculino', 'joaquim.b@email.com', 'senhaforte', 1960, 2, 7), (30, 'Livia', 'Andrade', '16992000030', 'Feminino', 'livia.a@email.com', 'senhaforte', 1985, 6, 17), (31, 'Marcos', 'Mion', '16992000031', 'Masculino', 'marcos.mion@email.com', 'senhaforte', 1978, 1, 23), (32, 'Nair', 'Belo', '16992000032', 'Feminino', 'nair.b@email.com', 'senhaforte', 1971, 9, 9), (33, 'Otavio', 'Mesquita', '16992000033', 'Masculino', 'otavio.m@email.com', 'senhaforte', 1966, 12, 11), (34, 'Patricia', 'Poeta', '16992000034', 'Feminino', 'patricia.p@email.com', 'senhaforte', 1981, 3, 27), (35, 'Raul', 'Gil', '16992000035', 'Masculino', 'raul.g@email.com', 'senhaforte', 1963, 7, 4),
-- Funcionários Administrativos (36-40)
(36, 'Roberto', 'Almeida', '16993000036', 'Masculino', 'roberto.a@email.com', 'senhasegura', 1985, 4, 22), (37, 'Sandra', 'Lima', '16993000037', 'Feminino', 'sandra.l@email.com', 'senhasegura', 1990, 9, 18), (38, 'Tania', 'Mara', '16993000038', 'Feminino', 'tania.m@email.com', 'senhasegura', 1988, 5, 31), (39, 'Ulisses', 'Guimarães', '16993000039', 'Masculino', 'ulisses.g@email.com', 'senhasegura', 1976, 2, 15), (40, 'Vera', 'Fischer', '16993000040', 'Feminino', 'vera.f@email.com', 'senhasegura', 1983, 10, 6);

-- Tabela: Aluno (20 registros)
INSERT INTO Aluno (ID_usuario, Nome_predio, ID_Unidade) VALUES
(1, 'Bloco de Computação', 1), (2, 'Bloco de Computação', 1), (3, 'Bloco de Computação', 1), (4, 'Prédio de Ciências Básicas', 1), (5, 'Prédio de Ciências Básicas', 1), (6, 'Prédio de Engenharia', 3), (7, 'Prédio de Engenharia', 3), (8, 'Prédio de Engenharia', 3), (9, 'Prédio de Ciências Básicas', 1), (10, 'Prédio de Ciências Básicas', 1), (11, 'Prédio de Letras e Artes', 2), (12, 'Prédio de Letras e Artes', 2), (13, 'Prédio de Letras e Artes', 2), (14, 'Prédio de Letras e Artes', 2), (15, 'Prédio de Letras e Artes', 2), (16, 'Prédio de Ciências Humanas', 2), (17, 'Prédio de Ciências Humanas', 2), (18, 'Prédio de Ciências Humanas', 2), (19, 'Prédio de Ciências Humanas', 2), (20, 'Prédio de Ciências Humanas', 2);

-- Tabela: Professor (15 registros)
INSERT INTO Professor (ID_usuario, Titulacao, ChefeSN, Nome_predio, ID_Unidade) VALUES
(21, 'Doutor', FALSE, 'Prédio de Ciências Básicas', 1), (22, 'Doutor', TRUE, 'Bloco de Computação', 1), (25, 'Associado', FALSE, 'Bloco de Computação', 1), (26, 'Associado', FALSE, 'Bloco de Computação', 1), (23, 'Associado', TRUE, 'Prédio de Engenharia', 3), (24, 'Doutor', FALSE, 'Prédio de Engenharia', 3), (27, 'Doutor', FALSE, 'Prédio de Ciências Básicas', 1), (28, 'Doutor', TRUE, 'Prédio de Letras e Artes', 2), (29, 'Livre-docência', TRUE, 'Prédio de Ciências Humanas', 2), (30, 'Associado', FALSE, 'Prédio de Letras e Artes', 2), (31, 'Associado', FALSE, 'Prédio de Ciências Humanas', 2), (32, 'Doutor', FALSE, 'Prédio de Letras e Artes', 2), (33, 'Associado', FALSE, 'Prédio de Ciências Humanas', 2), (34, 'Doutor', FALSE, 'Prédio de Letras e Artes', 2), (35, 'Livre-docência', FALSE, 'Prédio de Ciências Humanas', 2);

-- Tabela: Funcionario_Administrativo (5 registros)
INSERT INTO Funcionario_Administrativo (ID_funcionario) VALUES (36), (37), (38), (39), (40);

-- Tabela: Chefe_departamento (4 registros)
INSERT INTO Chefe_departamento (ID_Chefe, ID_Departamento) VALUES
(22, 1), (23, 2), (28, 3), (29, 4);

-- Tabela: Ministrar_aula (Professor x Disciplina)
INSERT INTO Ministrar_aula (ID_professor, ID_disciplina) VALUES
(21, 1), (21, 4), (22, 2), (22, 3), (22, 6), (23, 5), (28, 7), (28, 8), (29, 9), (29, 10), (29, 11), (30, 12), (25, 2), (31, 10), (32, 7);

-- Tabela: Turma (15 registros)
INSERT INTO Turma (Codigo_turma, ID_disciplina, Nome_turma, ano_letivo, Semestre_letivo, capacidade_turma, ID_Unidade, Nome_predio, Andar_sala, Numero_sala) VALUES
(1, 1, 'A', 2025, 1, 40, 1, 'Prédio de Ciências Básicas', 1, 101),
(2, 2, 'A', 2025, 1, 30, 1, 'Bloco de Computação', 1, 101),
(3, 3, 'A', 2025, 2, 25, 1, 'Bloco de Computação', 2, 201),
(4, 4, 'A', 2025, 1, 40, 1, 'Prédio de Ciências Básicas', 1, 102),
(5, 5, 'A', 2025, 2, 35, 3, 'Prédio de Engenharia', 1, 101),
(6, 6, 'A', 2025, 2, 25, 1, 'Bloco de Computação', 2, 201),
(7, 7, 'A', 2025, 1, 30, 2, 'Prédio de Letras e Artes', 1, 101),
(8, 8, 'A', 2025, 1, 30, 2, 'Prédio de Letras e Artes', 2, 201),
(9, 9, 'A', 2025, 1, 35, 2, 'Prédio de Ciências Humanas', 1, 101),
(10, 10, 'A', 2025, 1, 35, 2, 'Prédio de Ciências Humanas', 1, 102),
(11, 11, 'A', 2025, 2, 25, 2, 'Prédio de Ciências Humanas', 2, 201),
(12, 12, 'A', 2025, 2, 30, 2, 'Prédio de Letras e Artes', 1, 101),
(13, 2, 'B', 2025, 1, 30, 1, 'Bloco de Computação', 1, 101),
(14, 10, 'B', 2025, 1, 25, 2, 'Prédio de Ciências Humanas', 2, 201),
(15, 1, 'B', 2025, 1, 40, 1, 'Prédio de Ciências Básicas', 1, 102);

-- Tabela: Matricula (120 registros)
-- **SEÇÃO ATUALIZADA**: Registros duplicados corrigidos para garantir a consistência dos dados.
INSERT INTO Matricula (ID_Matricula, data_matricula, ID_aluno, Codigo_turma, Status, ID_professor) VALUES
-- Matrículas existentes (1-60)
(1, '2025-02-10', 1, 1, 'Ativa', 21), (2, '2025-02-10', 1, 2, 'Ativa', 22), (3, '2025-02-11', 2, 1, 'Ativa', 21), (4, '2025-02-11', 2, 13, 'Ativa', 25), (5, '2025-02-12', 3, 1, 'Concluida', 21), (6, '2025-02-12', 3, 2, 'Concluida', 22), (7, '2025-07-20', 1, 3, 'Ativa', 22), (8, '2025-07-20', 1, 6, 'Ativa', 22), (9, '2025-07-21', 2, 3, 'Ativa', 22), (10, '2025-02-13', 4, 15, 'Cancelada', 21), (11, '2025-02-13', 5, 1, 'Ativa', 21), (12, '2025-02-13', 5, 2, 'Ativa', 22),
(13, '2025-02-14', 6, 1, 'Ativa', 21), (14, '2025-02-14', 6, 4, 'Ativa', 21), (15, '2025-02-15', 7, 15, 'Ativa', 21), (16, '2025-02-15', 7, 4, 'Ativa', 21), (17, '2025-07-22', 6, 5, 'Ativa', 23), (18, '2025-07-22', 7, 5, 'Ativa', 23),
(19, '2025-02-10', 11, 7, 'Ativa', 28), (20, '2025-02-10', 11, 8, 'Ativa', 28), (21, '2025-02-11', 12, 7, 'Ativa', 32), (22, '2025-02-11', 12, 8, 'Ativa', 28), (23, '2025-07-20', 11, 12, 'Ativa', 30), (24, '2025-07-20', 12, 12, 'Ativa', 30), (25, '2025-02-12', 16, 9, 'Ativa', 29), (26, '2025-02-12', 16, 10, 'Ativa', 29), (27, '2025-02-13', 17, 9, 'Ativa', 29), (28, '2025-02-13', 17, 14, 'Ativa', 31), (29, '2025-07-21', 16, 11, 'Ativa', 29), (30, '2025-07-21', 17, 11, 'Ativa', 29),
(31, '2025-02-14', 4, 1, 'Ativa', 21), (32, '2025-02-14', 4, 2, 'Ativa', 22), (33, '2025-07-25', 5, 3, 'Ativa', 22), (34, '2025-07-25', 5, 6, 'Ativa', 22), (35, '2025-02-15', 1, 4, 'Concluida', 21),
(36, '2025-02-16', 8, 1, 'Ativa', 21), (37, '2025-02-16', 8, 4, 'Ativa', 21), (38, '2025-07-28', 8, 5, 'Ativa', 23), (39, '2025-02-17', 9, 1, 'Ativa', 21), (40, '2025-02-17', 10, 4, 'Ativa', 21),
(41, '2025-02-18', 13, 7, 'Ativa', 28), (42, '2025-02-18', 13, 8, 'Ativa', 28), (43, '2025-07-29', 13, 12, 'Ativa', 30),(44, '2025-02-19', 14, 7, 'Concluida', 32), (45, '2025-02-19', 15, 8, 'Ativa', 28),
(46, '2025-02-20', 18, 9, 'Ativa', 29), (47, '2025-02-20', 18, 10, 'Ativa', 29),(48, '2025-07-30', 18, 11, 'Ativa', 29),(49, '2025-02-21', 19, 9, 'Concluida', 29), (50, '2025-02-21', 20, 10, 'Ativa', 31),
(51, '2025-02-10', 3, 4, 'Concluida', 21), (52, '2025-07-21', 4, 3, 'Ativa', 22), (53, '2025-02-15', 9, 4, 'Ativa', 21), (54, '2025-07-22', 10, 5, 'Ativa', 23), (55, '2025-02-11', 14, 8, 'Concluida', 28),(56, '2025-07-20', 15, 12, 'Ativa', 30), (57, '2025-02-12', 19, 10, 'Concluida', 31),(58, '2025-07-21', 20, 11, 'Ativa', 29), (59, '2025-02-10', 2, 4, 'Ativa', 21), (60, '2025-02-14', 7, 1, 'Ativa', 21),
-- Novas matrículas (61-120)
(61, '2025-02-10', 6, 15, 'Ativa', 21), (62, '2025-02-10', 9, 15, 'Ativa', 21), (63, '2025-02-11', 10, 15, 'Ativa', 21), (64, '2025-02-11', 1, 13, 'Ativa', 25), (65, '2025-02-12', 2, 2, 'Concluida', 25), (66, '2025-02-12', 3, 13, 'Ativa', 25), (67, '2025-07-20', 4, 6, 'Ativa', 22), (68, '2025-07-20', 5, 6, 'Ativa', 22), (69, '2025-07-21', 3, 3, 'Ativa', 22), (70, '2025-02-13', 2, 15, 'Cancelada', 21), (71, '2025-02-13', 1, 15, 'Ativa', 21), (72, '2025-02-13', 3, 15, 'Ativa', 22),
(73, '2025-02-14', 8, 15, 'Ativa', 21), (74, '2025-02-14', 9, 4, 'Ativa', 21), (75, '2025-02-15', 10, 1, 'Ativa', 21), (76, '2025-02-15', 6, 4, 'Concluida', 21), (77, '2025-07-22', 8, 5, 'Ativa', 23), (78, '2025-07-22', 9, 5, 'Ativa', 23),
(79, '2025-02-10', 14, 7, 'Ativa', 28), (80, '2025-02-10', 15, 8, 'Ativa', 28), (81, '2025-02-11', 11, 7, 'Trancada', 32), (82, '2025-02-11', 13, 8, 'Ativa', 28), (83, '2025-07-20', 14, 12, 'Ativa', 30), (84, '2025-07-20', 20, 11, 'Ativa', 29), (85, '2025-02-12', 18, 9, 'Ativa', 29), (86, '2025-02-13', 19, 10, 'Ativa', 29), (87, '2025-02-13', 20, 9, 'Ativa', 29), (88, '2025-02-13', 16, 14, 'Ativa', 31), (89, '2025-07-21', 18, 11, 'Ativa', 29), (90, '2025-07-21', 19, 11, 'Ativa', 29),
(91, '2025-02-14', 2, 6, 'Ativa', 22), (92, '2025-02-14', 3, 6, 'Ativa', 22), (93, '2025-07-25', 1, 5, 'Cancelada', 23), (94, '2025-07-25', 2, 5, 'Ativa', 23), (95, '2025-02-15', 4, 4, 'Concluida', 21),
(96, '2025-02-16', 6, 1, 'Concluida', 21), (97, '2025-02-16', 7, 4, 'Trancada', 21), (98, '2025-07-28', 9, 5, 'Concluida', 23), (99, '2025-02-17', 10, 1, 'Concluida', 21), (100, '2025-02-17', 6, 4, 'Ativa', 21),
(101, '2025-02-18', 11, 14, 'Ativa', 31), (102, '2025-02-18', 12, 14, 'Ativa', 31), (103, '2025-07-29', 14, 11, 'Ativa', 29),(104, '2025-02-19', 15, 7, 'Concluida', 32), (105, '2025-02-19', 11, 8, 'Trancada', 28),
(106, '2025-02-20', 16, 9, 'Concluida', 29), (107, '2025-02-20', 17, 10, 'Ativa', 29),(108, '2025-07-30', 20, 11, 'Ativa', 29),(109, '2025-02-21', 16, 10, 'Concluida', 29), (110, '2025-02-21', 17, 14, 'Ativa', 31),
(111, '2025-02-10', 5, 4, 'Concluida', 21), (112, '2025-07-21', 1, 3, 'Trancada', 22), (113, '2025-02-15', 8, 4, 'Ativa', 21), (114, '2025-07-23', 6, 5, 'Cancelada', 23), (115, '2025-02-11', 11, 10, 'Concluida', 31),(116, '2025-07-20', 12, 11, 'Ativa', 29), (117, '2025-02-12', 17, 9, 'Concluida', 29),(118, '2025-07-21', 16, 12, 'Ativa', 30), (119, '2025-02-10', 4, 13, 'Ativa', 25), (120, '2025-02-14', 5, 15, 'Ativa', 21);

-- Tabela: Avaliacao e Feedback
-- A lógica de inserção se adapta ao novo número de matrículas.
INSERT INTO Avaliacao (ID_matricula, tipo_avaliacao, Nota) SELECT ID_Matricula, 'P1', (random() * 5 + 5)::int FROM Matricula WHERE Status IN ('Ativa', 'Concluida') ON CONFLICT (ID_matricula, tipo_avaliacao) DO NOTHING;
INSERT INTO Avaliacao (ID_matricula, tipo_avaliacao, Nota) SELECT ID_Matricula, 'P2', (random() * 6 + 4)::int FROM Matricula WHERE Status = 'Concluida' OR (Status = 'Ativa' AND random() < 0.5) ON CONFLICT (ID_matricula, tipo_avaliacao) DO NOTHING;
INSERT INTO Feedback (ID_remetente, ID_destinatario, ID_disciplina, Ano_letivo, Semestre_letivo, Comentario, Didatica) SELECT m.ID_aluno, m.ID_professor, t.ID_disciplina, t.ano_letivo, t.Semestre_letivo, 'Feedback construtivo sobre a didática.', (random()*3+2)::int FROM Matricula m JOIN Turma t ON m.Codigo_turma = t.Codigo_turma WHERE m.Status = 'Concluida' LIMIT 40;


SELECT setval('campus_id_campus_seq', (SELECT MAX(ID_Campus) FROM Campus));
SELECT setval('unidade_escolar_id_unidade_seq', (SELECT MAX(ID_Unidade) FROM Unidade_escolar));
SELECT setval('departamento_id_departamento_seq', (SELECT MAX(ID_Departamento) FROM Departamento));
SELECT setval('curso_id_curso_seq', (SELECT MAX(ID_Curso) FROM Curso));
SELECT setval('disciplina_id_disciplina_seq', (SELECT MAX(ID_disciplina) FROM Disciplina));
SELECT setval('turma_codigo_turma_seq', (SELECT MAX(Codigo_turma) FROM Turma));
SELECT setval('usuario_id_usuario_seq', (SELECT MAX(ID_usuario) FROM Usuario));
SELECT setval('matricula_id_matricula_seq', (SELECT MAX(ID_Matricula) FROM Matricula));
SELECT setval('feedback_id_feedback_seq', (SELECT COALESCE(MAX(ID_feedback), 1) FROM Feedback));
SELECT setval('aviso_id_aviso_seq', 1, false);
SELECT setval('mensagem_id_mensagem_seq', 1, false);