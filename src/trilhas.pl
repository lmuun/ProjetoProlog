:- consult('/elegibilidade.pl').

prerequisito_transitivo(Disciplina, Ancestral) :- 
    prerequisito(Disciplina, Ancestral).

prerequisito_transitivo(Disciplina, Ancestral) :-
    prerequisito(Disciplina, Pre),
    prerequisito_transitivo(Pre, Ancestral).

existe_ciclo(Disciplina) :-
    prerequisito_transitivo(Disciplina, Disciplina).

% trilha_valida(Aluno, MaxCreditosPorSemestre, Trilha) :-
    

