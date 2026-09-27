% Camada 3: fecho transitivo e geração de trilhas.

% prerequisito_transitivo(Disciplina, Ancestral): qualquer pré-requisito direto ou indireto.
prerequisito_transitivo(Disciplina, Ancestral) :-
    prerequisito(Disciplina, Ancestral).

prerequisito_transitivo(Disciplina, Ancestral) :-
    prerequisito(Disciplina, Intermediario),
    prerequisito_transitivo(Intermediario, Ancestral).

% existe_ciclo(Disciplina): verdadeiro se há um caminho de volta até a própria disciplina.
% A busca usa uma lista de visitados para evitar looping infinito mesmo na presença de um ciclo.
existe_ciclo(Disciplina) :-
    caminho_para(Disciplina, Disciplina, [Disciplina]).

caminho_para(Atual, Inicio, Visitados) :-
    prerequisito(Atual, Proximo),
    ( Proximo = Inicio
    ; \+ member(Proximo, Visitados),
      caminho_para(Proximo, Inicio, [Proximo | Visitados])
    ).

% prerequisitos_satisfeitos(Aluno, Disciplina, Selecionadas): exige que todos os
% pré-requisitos desta disciplina já tenham sido cursados ou já estejam na trilha.
prerequisitos_satisfeitos(Aluno, Disciplina, Selecionadas) :-
    forall(prerequisito(Disciplina, Pre),
           (cursou(Aluno, Pre) ; member(Pre, Selecionadas))).

% candidatos_semestre(Aluno, Disponiveis, Selecionadas, Lista): disciplina ainda não estudada
% e com todos os pré-requisitos já aprovados para a disputa do próximo semestre.
candidatos_semestre(Aluno, Disponiveis, Selecionadas, Candidatos) :-
    findall(Disciplina,
            (member(Disciplina, Disponiveis),
             \+ member(Disciplina, Selecionadas),
             \+ cursou(Aluno, Disciplina),
             disciplina(Disciplina, _, _, _),
             prerequisitos_satisfeitos(Aluno, Disciplina, Selecionadas)),
            Candidatos).

% gerar_semestre(Candidatos, Limite, Semestre): escolhe um subconjunto de candidatos
% cujo somatório de créditos não ultrapassa o limite informado. A escolha é feita por
% backtracking, permitindo enumerar multiplas trilhas válidas.
gerar_semestre([], _, []).

gerar_semestre([Disciplina | Resto], Limite, [Disciplina | Semestre]) :-
    disciplina(Disciplina, _, Creditos, _),
    Creditos =< Limite,
    NovoLimite is Limite - Creditos,
    gerar_semestre(Resto, NovoLimite, Semestre).

gerar_semestre([_ | Resto], Limite, Semestre) :-
    gerar_semestre(Resto, Limite, Semestre).

% remover_semestre(Semestre, Disponiveis, Restantes): remove do conjunto de disciplinas
% disponíveis as que já entraram no semestre corrente.
remover_semestre([], Disponiveis, Disponiveis).
remover_semestre([Disciplina | Resto], Disponiveis, Restantes) :-
    delete(Disponiveis, Disciplina, Intermediario),
    remover_semestre(Resto, Intermediario, Restantes).

% trilha_recursiva: constrói semestres sucessivos até que não haja mais disciplinas elegíveis
% ou o limite de segurança de 12 semestres seja alcançado.
trilha_recursiva(_, _, _, _, 0, []).

trilha_recursiva(Aluno, Disponiveis, Selecionadas, Limite, SemestresRestantes, [Semestre | Resto]) :-
    SemestresRestantes > 0,
    candidatos_semestre(Aluno, Disponiveis, Selecionadas, Candidatos),
    Candidatos \= [],
    gerar_semestre(Candidatos, Limite, Semestre),
    Semestre \= [],
    remover_semestre(Semestre, Disponiveis, Restantes),
    append(Semestre, Selecionadas, NovasSelecionadas),
    ProximoPasso is SemestresRestantes - 1,
    trilha_recursiva(Aluno, Restantes, NovasSelecionadas, Limite, ProximoPasso, Resto).

trilha_recursiva(_, _, _, _, _, []).

% trilha_valida(Aluno, MaxCreditosPorSemestre, Trilha):
% retorna uma sequência de semestres em que cada disciplina depende só de pré-requisitos
% já concluídos ou já selecionados para a trilha. O limite de 12 semestres é segurança
% contra explosão combinatória.
trilha_valida(Aluno, MaxCreditosPorSemestre, Trilha) :-
    integer(MaxCreditosPorSemestre),
    MaxCreditosPorSemestre > 0,
    findall(Disciplina, disciplina(Disciplina, _, _, _), Disponiveis),
    trilha_recursiva(Aluno, Disponiveis, [], MaxCreditosPorSemestre, 12, Trilha).

