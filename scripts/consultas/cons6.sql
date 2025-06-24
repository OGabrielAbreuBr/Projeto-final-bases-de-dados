-- Consulta 6: Verificando os alunos que passaram em Cálculo
SELECT
  a.ID_Usuario,
  AVG(av.nota)
FROM
  Disciplina d  JOIN Turma t
  ON d.ID_Disciplina = t.ID_Disciplina
  JOIN Matricula m
  ON m.Codigo_turma = t.Codigo_turma
  JOIN Aluno a
  ON m.ID_Aluno = a.ID_Usuario
  JOIN Avaliacao av ON
  av.ID_matricula = m.ID_matricula
WHERE d.Nome_disciplina = 'Cálculo I'
GROUP BY a.ID_Usuario
HAVING AVG(av.nota) >= 5;