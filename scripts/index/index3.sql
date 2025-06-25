-- criação de index para consultar notas acima da média 
DROP INDEX IF EXISTS provas;
EXPLAIN ANALYZE
SELECT

    av.tipo_avaliacao,
    av.Nota
FROM
    Avaliacao av
WHERE
    av.tipo_avaliacao = 'P1' AND
    av.Nota >= 5;

CREATE INDEX provas ON Avaliacao (tipo_avaliacao,Nota);

EXPLAIN ANALYZE
SELECT

    av.tipo_avaliacao,
    av.Nota
FROM
    Avaliacao av
WHERE
    av.tipo_avaliacao = 'P1' AND
    av.Nota >= 5;
