-- Consulta 1: Lista cursos e departamentos da Escola de Engenharia.
SELECT
    c.nome_Curso AS "Nome do Curso",
    d.Nome_departamento AS "Departamento Responsável"
FROM
    Curso c
JOIN
    Departamento_curso dc ON c.ID_Curso = dc.ID_Curso
JOIN
    Departamento d ON dc.ID_Departamento = d.ID_Departamento
JOIN
    Unidade_escolar u ON c.ID_Unidade = u.ID_Unidade
WHERE
    u.Nome_Unidade = 'Escola de Engenharia';