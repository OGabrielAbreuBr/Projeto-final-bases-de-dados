CREATE OR REPLACE VIEW vw_media_calculo_2025_2 AS
SELECT
    d.Nome_Disciplina,
    t.ano_letivo,
    t.Semestre_letivo,
    ROUND(AVG(av.Nota), 2) AS "Média Geral"
FROM
    Avaliacao av
JOIN
    Matricula m ON av.ID_matricula = m.ID_Matricula
JOIN
    Turma t ON m.Codigo_turma = t.Codigo_turma
JOIN
    Disciplina d ON t.ID_disciplina = d.ID_disciplina
WHERE
    d.Nome_Disciplina = 'Cálculo I'
    AND t.ano_letivo = 2025
    AND t.Semestre_letivo = 1
GROUP BY
    d.Nome_Disciplina, t.ano_letivo, t.Semestre_letivo;


 SELECT * FROM vw_media_calculo_2025_2;