-- Consulta 5: Compara a capacidade da turma com o número de alunos matriculados.
SELECT
    t.Codigo_turma,
    d.Nome_Disciplina,
    t.Nome_turma,
    t.capacidade_turma AS "Capacidade",
    COUNT(m.ID_Matricula) AS "Alunos Matriculados"
FROM
    Turma t
JOIN
    Disciplina d ON t.ID_disciplina = d.ID_disciplina
LEFT JOIN -- LEFT JOIN para incluir turmas sem nenhum aluno matriculado
    Matricula m ON t.Codigo_turma = m.Codigo_turma AND m.Status = 'Ativa'
WHERE
    t.ano_letivo = 2025 AND t.Semestre_letivo = 1
GROUP BY
    t.Codigo_turma, d.Nome_Disciplina, t.Nome_turma, t.capacidade_turma
ORDER BY
    d.Nome_Disciplina, t.Nome_turma;