:- dynamic disciplina/4.
:- dynamic prerequisito/2.
:- dynamic cursou/2.

% Camada 1: base de fatos do currículo e do histórico dos alunos.

% disciplina(Nome, Tipo, Creditos, SemestreSugerido)

% Primeiro período

disciplina(algoritmos_1, obrigatoria, 4, 1).
disciplina(calculo_1, obrigatoria, 4, 1).
disciplina(introducao_cs, obrigatoria, 2, 1).
disciplina(geometria_analitica, obrigatoria, 4, 1).

% Segundo período
disciplina(algoritmos_2, obrigatoria, 4, 2).
disciplina(calculo_2, obrigatoria, 4, 2).
disciplina(circuitos_digitais, obrigatoria, 4, 2).
disciplina(algebra_linear, obrigatoria, 4, 2).

% Terceiro período
disciplina(estrutura_de_dados, obrigatoria, 4, 3).
disciplina(organizacao_computadores, obrigatoria, 4, 3).
disciplina(calculo_3, obrigatoria, 4, 3).

% Quarto período
disciplina(paradigmas_programacao, obrigatoria, 4, 4).
disciplina(sistemas_operacionais, obrigatoria, 4, 4).
disciplina(banco_de_dados, obrigatoria, 4, 4).

% Quinto período
disciplina(compiladores, obrigatoria, 4, 5).
disciplina(redes_de_computadores, obrigatoria, 4, 5).
disciplina(engenharia_de_software, obrigatoria, 4, 5).

% Sexto período
disciplina(inteligencia_artificial, eletiva, 4, 6).
disciplina(seguranca_informacao, eletiva, 4, 6).
disciplina(desenvolvimento_web, eletiva, 4, 6).
disciplina(computacao_grafica, eletiva, 4, 6).

% Disciplinas extras
disciplina(analise_algoritmos, obrigatoria, 4, 6).
disciplina(automatos, obrigatoria, 4, 7).
disciplina(teoria_computacao, obrigatoria, 4, 7).
disciplina(projeto_integrador, obrigatoria, 6, 8).

% prerequisito(Disciplina, Prerequisito)
prerequisito(algoritmos_2, algoritmos_1).
prerequisito(estrutura_de_dados, algoritmos_2).
prerequisito(paradigmas_programacao, estrutura_de_dados).
prerequisito(compiladores, paradigmas_programacao).
prerequisito(calculo_2, calculo_1).
prerequisito(calculo_3, calculo_2).
prerequisito(algebra_linear, geometria_analitica).
prerequisito(organizacao_computadores, circuitos_digitais).
prerequisito(sistemas_operacionais, organizacao_computadores).
prerequisito(banco_de_dados, estrutura_de_dados).
prerequisito(redes_de_computadores, sistemas_operacionais).
prerequisito(engenharia_de_software, banco_de_dados).
prerequisito(inteligencia_artificial, estrutura_de_dados).
prerequisito(seguranca_informacao, redes_de_computadores).
prerequisito(desenvolvimento_web, banco_de_dados).
prerequisito(computacao_grafica, estrutura_de_dados).
prerequisito(computacao_grafica, algebra_linear).
prerequisito(analise_algoritmos, paradigmas_programacao).
prerequisito(automatos, calculo_3).
prerequisito(teoria_computacao, automatos).
prerequisito(projeto_integrador, engenharia_de_software).
prerequisito(projeto_integrador, desenvolvimento_web).

% cursou(Aluno, Disciplina)
% Aluno adiantado: Lucas
cursou(lucas, algoritmos_1).
cursou(lucas, calculo_1).
cursou(lucas, introducao_cs).
cursou(lucas, geometria_analitica).
cursou(lucas, algoritmos_2).
cursou(lucas, calculo_2).
cursou(lucas, circuitos_digitais).
cursou(lucas, algebra_linear).
cursou(lucas, estrutura_de_dados).
cursou(lucas, organizacao_computadores).
cursou(lucas, calculo_3).
cursou(lucas, paradigmas_programacao).
cursou(lucas, sistemas_operacionais).
cursou(lucas, banco_de_dados).
cursou(lucas, compiladores).
cursou(lucas, redes_de_computadores).
cursou(lucas, inteligencia_artificial).
cursou(lucas, seguranca_informacao).

% Aluno no ritmo normal: Beatriz
cursou(beatriz, algoritmos_1).
cursou(beatriz, calculo_1).
cursou(beatriz, introducao_cs).
cursou(beatriz, geometria_analitica).
cursou(beatriz, algoritmos_2).
cursou(beatriz, calculo_2).
cursou(beatriz, circuitos_digitais).
cursou(beatriz, algebra_linear).
cursou(beatriz, estrutura_de_dados).
cursou(beatriz, organizacao_computadores).
cursou(beatriz, calculo_3).

% Aluno atrasado: Carlos
cursou(carlos, algoritmos_1).
cursou(carlos, introducao_cs).
cursou(carlos, geometria_analitica).
cursou(carlos, circuitos_digitais).

% 25 disciplinas cadastradas.
% pré-requisitos de compiladores -> paradigmas_programacao -> estrutura_de_dados -> algoritmos_2 -> algoritmos_1 tem profundidade 5.