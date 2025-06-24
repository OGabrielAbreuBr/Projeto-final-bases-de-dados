-- Consulta 7: Calcula a média de feedback em didática para cada professor.
SELECT
    u.Nome || ' ' || u.Sobrenome AS "Nome do Professor",
    ROUND(AVG(f.Didatica), 2) AS "Média de Didática"
FROM
    Feedback f
JOIN
    Professor p ON f.ID_destinatario = p.ID_usuario
JOIN
    Usuario u ON p.ID_usuario = u.ID_usuario
GROUP BY
    u.Nome, u.Sobrenome
ORDER BY
    "Média de Didática" DESC;