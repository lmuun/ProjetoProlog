% prerequisitos_ok(Aluno, Disciplina) : verdadeiro se todos os pré-requisitos diretos 
% já foram cursados

prerequisitos_ok(Aluno, Disciplina) :-
    disciplina(Disciplina, _, _, _),
    \+ (prerequisito(Disciplina, Pre), \+ cursou(Aluno, Pre)).

% pode_cursar(Aluno, Disciplina) : elegível e ainda não cursada (usa negação por falha)

pode_cursar(Aluno, Disciplina) :-
    disciplina(Disciplina, _, _, _),
    \+ cursou(Aluno, Disciplina),
    prerequisitos_ok(Aluno, Disciplina).

% disciplinas_liberadas(Aluno, Lista) : todas as disciplinas que pode_cursar agora, via 
% findall ou setoff

disciplinas_liberadas(Aluno, Lista) :-
    findall(Disciplina, pode_cursar(Aluno, Disciplina), Lista).


% disciplinas_pendentes(Aluno, Lista) : todas as obrigatórias ainda não cursadas, 
% independentemente de elegibilidade

disciplinas_pendentes(Aluno, Lista) :-
    findall(Disciplina, (disciplina(Disciplina, obrigatoria, _, _), \+ cursou(Aluno, Disciplina)), Lista).


% creditos_cursados(Aluno, Total) : soma dos créditos de tudo que o aluno já cursou

creditos_cursados(Aluno, Total) :-
    findall(Creditos, (cursou(Aluno, Disc), disciplina(Disc, _, Creditos, _)), ListaCreditos),
    sum_list(ListaCreditos, Total).