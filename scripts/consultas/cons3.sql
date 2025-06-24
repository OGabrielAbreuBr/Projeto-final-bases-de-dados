-- Consulta 3: Calcula a média geral de notas para cada curso.
SELECT
    c.nome_Curso AS "Curso",
    ROUND(AVG(av.Nota), 2) AS "Média Geral das Notas"
FROM
    Curso c
JOIN
    Estar_na_Ementa ee ON c.ID_Curso = ee.ID_curso
JOIN
    Disciplina d ON ee.ID_disciplina = d.ID_disciplina
JOIN
    Turma t ON d.ID_disciplina = t.ID_disciplina
JOIN
    Matricula m ON t.Codigo_turma = m.Codigo_turma
JOIN
    Avaliacao av ON m.ID_Matricula = av.ID_matricula
GROUP BY
    c.nome_Curso
ORDER BY
    "Média Geral das Notas" DESC;