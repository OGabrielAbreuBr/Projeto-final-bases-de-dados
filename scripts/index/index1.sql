DROP INDEX IF EXISTS idx_sala_cobertura_capacidade;
EXPLAIN ANALYSE
SELECT *
FROM Sala_de_Aula
WHERE
    Nome_predio = 'Prédio de Ciências Básicas' AND Capacidade_sala > 70;

CREATE INDEX IF NOT EXISTS idx_sala_cobertura_capacidade ON Sala_de_Aula (Nome_predio, Capacidade_Sala);
EXPLAIN ANALYSE
SELECT *
FROM Sala_de_Aula
WHERE
    Nome_predio = 'Prédio de Ciências Básicas' AND Capacidade_sala > 70;