-- criar index para coletar os feedbacks para aquele semestre específico

DROP INDEX IF EXISTS Ano_Semestre_feedback;

EXPLAIN ANALYZE
SELECT
    d.Nome_Disciplina,
    ROUND(AVG(f.Didatica), 2) AS "Média Didática",
    ROUND(AVG(f.Relevancia_do_Conteudo), 2) AS "Média Relevância",
    ROUND(AVG(f.Material_de_Apoio), 2) AS "Média Material de Apoio",
    ROUND(AVG(f.Infraestrutura_da_Sala), 2) AS "Média Infraestrutura"
FROM
    Feedback f
JOIN
    Disciplina d ON f.ID_disciplina = d.ID_disciplina
WHERE
    f.Ano_letivo = 2025 AND f.Semestre_letivo = 1
GROUP BY
    d.Nome_Disciplina
ORDER BY
    d.Nome_Disciplina;

CREATE INDEX Ano_Semestre_feedback ON Feedback (Ano_Letivo,semestre_letivo);

EXPLAIN ANALYZE
SELECT
    d.Nome_Disciplina,
    ROUND(AVG(f.Didatica), 2) AS "Média Didática",
    ROUND(AVG(f.Relevancia_do_Conteudo), 2) AS "Média Relevância",
    ROUND(AVG(f.Material_de_Apoio), 2) AS "Média Material de Apoio",
    ROUND(AVG(f.Infraestrutura_da_Sala), 2) AS "Média Infraestrutura"
FROM
    Feedback f
JOIN
    Disciplina d ON f.ID_disciplina = d.ID_disciplina
WHERE
    f.Ano_letivo = 2025 AND f.Semestre_letivo = 1
GROUP BY
    d.Nome_Disciplina
ORDER BY
    d.Nome_Disciplina;