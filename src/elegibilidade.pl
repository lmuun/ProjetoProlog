% Camada 2: regras de elegibilidade.

% aluno_existe(Aluno): garante que o aluno realmente existe no histórico do sistema.
aluno_existe(Aluno) :-
    cursou(Aluno, _).

% disciplina_existe(Disciplina): garante que a disciplina existe na grade curricular.
disciplina_existe(Disciplina) :-
    disciplina(Disciplina, _, _, _).

% prerequisitos_ok(Aluno, Disciplina): todos os pré-requisitos diretos já foram cursados.
prerequisitos_ok(Aluno, Disciplina) :-
    aluno_existe(Aluno),
    disciplina_existe(Disciplina),
    forall(prerequisito(Disciplina, Pre), cursou(Aluno, Pre)).

% pode_cursar(Aluno, Disciplina): disciplina é elegível e ainda não foi cursada.
% A negação por falha (\+) evita que o aluno repita disciplina já concluída.
pode_cursar(Aluno, Disciplina) :-
    aluno_existe(Aluno),
    disciplina_existe(Disciplina),
    \+ cursou(Aluno, Disciplina),
    prerequisitos_ok(Aluno, Disciplina).

% disciplinas_liberadas(Aluno, Lista): todas as disciplinas que podem ser cursadas agora.
% Usamos findall/3 para coletar resultados sem exigir conjunto ordenado.
disciplinas_liberadas(Aluno, Lista) :-
    aluno_existe(Aluno),
    findall(Disciplina, pode_cursar(Aluno, Disciplina), Tmp),
    sort(Tmp, Lista).

% disciplinas_pendentes(Aluno, Lista): todas as obrigatórias que ainda faltam.
disciplinas_pendentes(Aluno, Lista) :-
    aluno_existe(Aluno),
    findall(Disciplina,
            (disciplina(Disciplina, obrigatoria, _, _),
             \+ cursou(Aluno, Disciplina)),
            Tmp),
    sort(Tmp, Lista).

% creditos_cursados(Aluno, Total): somatório dos créditos já concluídos pelo aluno.
creditos_cursados(Aluno, Total) :-
    aluno_existe(Aluno),
    findall(Creditos,
            (cursou(Aluno, Disciplina),
             disciplina(Disciplina, _, Creditos, _)),
            ListaCreditos),
    sum_list(ListaCreditos, Total).