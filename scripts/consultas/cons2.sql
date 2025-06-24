-- Consulta 2: Encontra professores que lecionam mais de uma disciplina.
SELECT
    p.ID_usuario,
    u.Nome || ' ' || u.Sobrenome AS "Nome do Professor",
    COUNT(ma.ID_disciplina) AS "Quantidade de Disciplinas"
FROM
    Professor p
JOIN
    Usuario u ON p.ID_usuario = u.ID_usuario
JOIN
    Ministrar_aula ma ON p.ID_usuario = ma.ID_professor
GROUP BY
    p.ID_usuario, u.Nome, u.Sobrenome
HAVING
    COUNT(ma.ID_disciplina) > 1