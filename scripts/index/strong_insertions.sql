-- Inserindo 10.000 novas Salas de Aula
INSERT INTO Sala_de_Aula (ID_Unidade, Nome_predio, Andar_sala, Numero_sala, Capacidade_sala)
SELECT
    CASE escolha_aleatoria
        WHEN 0 THEN 1 -- Instituto de Computação e Exatas
        WHEN 1 THEN 1 -- Instituto de Computação e Exatas
        WHEN 2 THEN 3 -- Escola de Engenharia
        WHEN 3 THEN 2 -- Faculdade de Letras e Ciências Sociais
        ELSE 2        -- Faculdade de Letras e Ciências Sociais
    END AS ID_Unidade,
    CASE escolha_aleatoria
        WHEN 0 THEN 'Bloco de Computação'
        WHEN 1 THEN 'Prédio de Ciências Básicas'
        WHEN 2 THEN 'Prédio de Engenharia'
        WHEN 3 THEN 'Prédio de Letras e Artes'
        ELSE 'Prédio de Ciências Humanas'
    END AS Nome_predio,
    (s / 2000) + 1 AS Andar_sala,
    (s % 2000) + 1000 AS Numero_sala, 
    (random() * 80 + 20)::int AS Capacidade_sala
FROM
    (SELECT s, (random() * 4)::int as escolha_aleatoria FROM generate_series(1, 10000) AS s) AS series_com_escolha;


-- Inserindo 20.000 novas Avaliações
INSERT INTO Avaliacao (ID_matricula, tipo_avaliacao, Nota)
SELECT
    (random() * 119 + 1)::int,
    'Avaliacao Extra ' || s,   
    (random() * 10)::int       
FROM generate_series(1, 20000) AS s
ON CONFLICT (ID_matricula, tipo_avaliacao) DO NOTHING; 

-- Inserindo 10.000 novos Feedbacks
INSERT INTO Feedback (ID_remetente, ID_destinatario, ID_disciplina, Ano_letivo, Semestre_letivo, Comentario, Didatica, Relevancia_do_Conteudo, Material_de_Apoio, Infraestrutura_da_Sala)
SELECT
    m.ID_aluno,
    m.ID_professor,
    t.ID_disciplina,
    t.ano_letivo,
    t.Semestre_letivo,
    'Comentário gerado artificialmente para teste de volume ' || s,
    (random() * 4 + 1)::int,
    (random() * 4 + 1)::int,
    (random() * 4 + 1)::int,
    (random() * 4 + 1)::int
FROM
    generate_series(1, 10000) AS s,
    (SELECT * FROM Matricula WHERE ID_professor IS NOT NULL ORDER BY random() LIMIT 1) AS m
JOIN
    Turma t ON m.Codigo_turma = t.Codigo_turma;