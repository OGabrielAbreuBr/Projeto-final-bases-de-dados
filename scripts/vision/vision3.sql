CREATE OR REPLACE VIEW vw_contagem_alunos_exatas AS
SELECT
    COUNT(DISTINCT a.ID_usuario) AS "Total de Alunos Ativos em Exatas"
FROM
    Aluno a
JOIN
    Matricula m ON a.ID_usuario = m.ID_aluno
WHERE
    a.ID_Unidade IN (1, 3)
    AND m.Status = 'Ativa';
    
SELECT * FROM vw_contagem_alunos_exatas;