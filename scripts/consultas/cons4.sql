-- Consulta 4: Lista 5 alunos de Ciência da Computação na disciplina de Banco de Dados.
SELECT
    u.Nome || ' ' || u.Sobrenome AS "Nome do Aluno",
    c.nome_Curso AS "Curso do Aluno",
    u.ID_usuario AS "ID"
FROM 
    Usuario u
JOIN
    Matricula m ON u.ID_usuario = m.ID_aluno
JOIN
    Turma t ON m.Codigo_turma = t.Codigo_turma
JOIN
    Disciplina d ON t.ID_disciplina = d.ID_disciplina
JOIN -- Join para garantir que o aluno é do curso de Ciência da Computação
    Estar_na_Ementa ee ON d.ID_disciplina = ee.ID_disciplina
JOIN
    Curso c ON ee.ID_curso = c.ID_Curso AND c.nome_Curso = 'Ciência da Computação'
WHERE
    d.Nome_Disciplina = 'Banco de Dados' AND m.Status = 'Ativa'
LIMIT 5;