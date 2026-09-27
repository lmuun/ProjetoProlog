:- ensure_loaded('curriculum.pl').
:- ensure_loaded('elegibilidade.pl').
:- ensure_loaded('trilhas.pl').

% Demonstração do sistema: executa, em sequência, as três camadas.
demo :-
    writeln('--- Camada 1: disciplinas do 2º semestre ---'),
    findall(Disciplina, disciplina(Disciplina, _, _, 2), Semestre2),
    writeln(Semestre2),
    nl,
    writeln('--- Camada 2: disciplinas liberadas para Beatriz ---'),
    disciplinas_liberadas(beatriz, LiberadasBeatriz),
    writeln(LiberadasBeatriz),
    writeln('--- Camada 2: disciplinas pendentes para Carlos ---'),
    disciplinas_pendentes(carlos, PendentesCarlos),
    writeln(PendentesCarlos),
    nl,
    writeln('--- Camada 3: pré-requisitos transitivos de compiladores ---'),
    prerequisito_transitivo(compiladores, Ancestral),
    format('compiladores -> ~w~n', [Ancestral]),
    writeln('--- Camada 3: trilha válida para Beatriz ---'),
    trilha_valida(beatriz, 8, Trilha),
    writeln(Trilha).

