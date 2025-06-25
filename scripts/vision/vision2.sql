-- Facilita a busca
DROP VIEW IF EXISTS vw_matriculas_tardias_2025_1;

CREATE OR REPLACE VIEW vw_matriculas_tardias_2025_1 AS
SELECT
    m.id_matricula,m.data_matricula
FROM
    Matricula m
JOIN
    Turma t ON m.Codigo_turma = t.Codigo_turma
WHERE
    t.ano_letivo = 2025
    AND t.Semestre_letivo = 1
    AND m.data_matricula > '2025-02-15';

SELECT * FROM vw_matriculas_tardias_2025_1;