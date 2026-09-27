# Decisões do sistema

## 1. Registros pequenos em vez de listas grandes

**O que priorizamos:** registrar cada disciplina, pré-requisito e matéria cursada como um fato separado, em vez de guardar todas as informações em uma lista dentro de um único registro.

**Por que faz sentido aqui:** assim, o Prolog pode combinar os fatos conforme a pergunta. Por exemplo, ele pode procurar as disciplinas de um semestre, descobrir o que exige `algoritmos_2` ou consultar o histórico da Beatriz sem precisar desmontar uma estrutura grande.

**No código:**

```
disciplina(algoritmos_2, obrigatoria, 4, 2).
prerequisito(algoritmos_2, algoritmos_1).
cursou(beatriz, algoritmos_1).
```

Cada linha guarda uma informação: a primeira descreve a disciplina, a segunda registra seu pré-requisito e a terceira registra algo que a aluna já cursou.

## 2. Fatos dinâmicos para os testes

**O que priorizamos:** deixar os fatos principais do currículo como dados que os testes podem alterar temporariamente.

**Por que isso acontece:** alguns testes precisam simular uma situação que não existe no cadastro normal. Por exemplo, eles acrescentam um pré-requisito fictício para confirmar que o sistema detecta ciclos e depois removem esses fatos. A declaração `dynamic` permite essas alterações durante a execução.

**No código:**

```prolog
:- dynamic disciplina/4.
:- dynamic prerequisito/2.
:- dynamic cursou/2.

assertz(prerequisito(ciclo_a, ciclo_b)),
assertz(prerequisito(ciclo_b, ciclo_a)),
existe_ciclo(ciclo_a),
retractall(prerequisito(ciclo_a, ciclo_b)),
retractall(prerequisito(ciclo_b, ciclo_a)).
```

Os dois primeiros comandos acrescentam fatos para o teste; os dois últimos limpam o cadastro depois. Essa alteração temporária é usada nos testes, não para montar as trilhas.

## 3. Elegibilidade: conferir todas as condições

**O que priorizamos:** só liberar uma disciplina quando o aluno e a disciplina existem, a matéria ainda não foi cursada e todos os pré-requisitos diretos foram concluídos.

**Por que faz sentido aqui:** uma matéria não deve ser recomendada só porque o aluno passou em um dos pré-requisitos; precisa ter passado em todos. E uma matéria já concluída não deve aparecer de novo como recomendação.

**No código:**

```prolog
prerequisitos_ok(Aluno, Disciplina) :-
	aluno_existe(Aluno),
	disciplina_existe(Disciplina),
	forall(prerequisito(Disciplina, Pre), cursou(Aluno, Pre)).

pode_cursar(Aluno, Disciplina) :-
	aluno_existe(Aluno),
	disciplina_existe(Disciplina),
	\+ cursou(Aluno, Disciplina),
	prerequisitos_ok(Aluno, Disciplina).
```

`forall/2` significa, neste caso, “para cada pré-requisito, confirme que o aluno já o cursou”. `\+ cursou(...)` significa que não há um fato indicando que a matéria já foi concluída.

## 4. `findall/3` em vez de `setof/3`

**O que priorizamos:** reunir as respostas com `findall/3` e depois organizá-las com `sort/2`.

**Qual é a diferença:** `findall/3` sempre devolve uma lista, inclusive `[]` quando não encontra nenhuma resposta. `setof/3` organiza e remove repetições por conta própria, mas falha quando não há respostas. Para este sistema, mostrar uma lista vazia é mais útil do que fazer a consulta falhar.

**No código:**

```
findall(Disciplina, pode_cursar(Aluno, Disciplina), Tmp),
sort(Tmp, Lista).
```

Primeiro o sistema coleta as disciplinas liberadas. Depois, `sort/2` coloca os nomes em ordem e remove eventuais repetidos. Assim, ficamos com o resultado vazio útil de `findall/3` e também com uma lista final organizada.

## 5. Recursão para percorrer pré-requisitos

**O que priorizamos:** seguir a cadeia de pré-requisitos passo a passo, em vez de cadastrar manualmente todos os pré-requisitos indiretos.

**Por que faz sentido aqui:** se `compiladores` exige `paradigmas_programacao`, que exige `estrutura_de_dados`, o sistema consegue continuar seguindo a cadeia e encontrar matérias anteriores, como `algoritmos_1`.

**No código:**

```
prerequisito_transitivo(Disciplina, Ancestral) :-
	prerequisito(Disciplina, Ancestral).

prerequisito_transitivo(Disciplina, Ancestral) :-
	prerequisito(Disciplina, Intermediario),
	prerequisito_transitivo(Intermediario, Ancestral).
```

A primeira regra encontra um pré-requisito direto. A segunda continua a busca a partir dele, para evitar ciclos na grade, existe uma verificação separada que guarda os nomes já visitados:

```
caminho_para(Atual, Inicio, Visitados) :-
	prerequisito(Atual, Proximo),
	( Proximo = Inicio
	; \+ member(Proximo, Visitados),
	  caminho_para(Proximo, Inicio, [Proximo | Visitados])
	).
```

Essa lista impede que a verificação de ciclos percorra o mesmo caminho repetidamente. A busca transitiva normal pressupõe que a grade não tenha ciclos; `existe_ciclo/1` serve para identificá-los.

## 6. Trilhas em listas temporárias, com limite de créditos

**O que priorizamos:** testar combinações usando listas temporárias, sem alterar o cadastro de disciplinas.

**Por que faz sentido aqui:** o Prolog pode tentar incluir ou deixar de fora cada disciplina e voltar atrás para explorar outra combinação. Como a tentativa fica nas listas da busca, uma alternativa não deixa alterações no currículo quando outra é testada.

**No código:**

```
gerar_semestre([Disciplina | Resto], Limite, [Disciplina | Semestre]) :-
	disciplina(Disciplina, _, Creditos, _),
	Creditos =< Limite,
	NovoLimite is Limite - Creditos,
	gerar_semestre(Resto, NovoLimite, Semestre).

gerar_semestre([_ | Resto], Limite, Semestre) :-
	gerar_semestre(Resto, Limite, Semestre).
```

Uma regra tenta colocar a disciplina no semestre e desconta seus créditos do limite. A outra pula a disciplina e tenta a próxima. 
A trilha também respeita os pré-requisitos já cursados ou incluídos em semestres anteriores. 
A busca para depois de 12 semestres como proteção contra uma procura excessivamente longa, com currículos grandes, ainda podem existir muitas combinações para testar.