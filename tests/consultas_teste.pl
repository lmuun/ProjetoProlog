:- consult('src/main.pl').

% Teste 1: disciplina do semestre sugerido
% Resultado esperado: [algebra_linear, algoritmos_2, calculo_2, circuitos_digitais]
teste_semestre_2 :-
    findall(Disciplina, disciplina(Disciplina, _, _, 2), Lista),
    sort(Lista, Esperado),
    Esperado = [algebra_linear, algoritmos_2, calculo_2, circuitos_digitais].

% Teste 2: disciplinas liberadas e pendentes para alunos diferentes
% Lucas está adiantado e Beatriz está em ritmo normal.
teste_liberadas_e_pendentes :-
    disciplinas_liberadas(beatriz, LiberadasBeatriz),
    member(paradigmas_programacao, LiberadasBeatriz),
    disciplinas_pendentes(carlos, PendentesCarlos),
    member(algoritmos_2, PendentesCarlos),
    member(calculo_2, PendentesCarlos).

% Teste 3: negação por falha é decisiva para a elegibilidade
% Se o aluno ainda não concluiu algoritmos_2, estrutura_de_dados não é liberada.
teste_negao_por_falha :-
    assertz(cursou(aluno_teste, algoritmos_1)),
    \+ pode_cursar(aluno_teste, estrutura_de_dados),
    assertz(cursou(aluno_teste, algoritmos_2)),
    pode_cursar(aluno_teste, estrutura_de_dados),
    retractall(cursou(aluno_teste, algoritmos_1)),
    retractall(cursou(aluno_teste, algoritmos_2)).

% Teste 4: fecho transitivo para a cadeia de profundidade ≥ 3
% compiladores -> paradigmas_programacao -> estrutura_de_dados -> algoritmos_2 -> algoritmos_1
teste_prerequisito_transitivo :-
    prerequisito_transitivo(compiladores, algoritmos_1).

% Teste 5: trilha válida com limite de crédito por semestre
% A trilha deve ser não vazia e respeitar o limite por semestre.
teste_trilha_valida :-
    trilha_valida(beatriz, 8, Trilha),
    Trilha = [_ | _],
    forall(member(Semestre, Trilha),
           (sum_credits(Semestre, Total), Total =< 8)).

sum_credits([], 0).
sum_credits([Disciplina | Resto], Total) :-
    disciplina(Disciplina, _, Creditos, _),
    sum_credits(Resto, Restante),
    Total is Creditos + Restante.

% Teste 6: detecção explícita de ciclo na grade
% Inserção temporária de um ciclo para confirmar a detecção.
teste_existe_ciclo :-
    assertz(prerequisito(ciclo_a, ciclo_b)),
    assertz(prerequisito(ciclo_b, ciclo_a)),
    existe_ciclo(ciclo_a),
    retractall(prerequisito(ciclo_a, ciclo_b)),
    retractall(prerequisito(ciclo_b, ciclo_a)).

consultas_teste :-
    teste_semestre_2,
    teste_liberadas_e_pendentes,
    teste_negao_por_falha,
    teste_prerequisito_transitivo,
    teste_trilha_valida,
    teste_existe_ciclo,
    writeln('Todos os testes passaram.').
