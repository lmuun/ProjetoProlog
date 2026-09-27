# Como executar no SWI-Prolog

1. Abra o SWI-Prolog Desktop.
2. No console, digite ou cole este comando completo e pressione `Enter`:

```
consult('C:/Users/J.Doe/Desktop/ProjetoProlog/src/main.pl').
demo.
```

Esse comando carrega o arquivo principal, que também carrega os módulos do sistema, e executa a demonstração.

Se a pasta do projeto estiver em outro local, substitua `C:/Users/J.Doe/Desktop/ProjetoProlog` pelo caminho da pasta onde você salvou o projeto. Use barras `/` no caminho.

## Como executar os testes

No SWI-Prolog Desktop, use `File` -> `Consult...` e selecione `tests/consultas_teste.pl`. Depois, execute no console:

```
consultas_teste.
```

Ou carregue o arquivo e execute os testes com uma única consulta no console (ajuste o caminho se o projeto estiver em outro local):

```
consult('C:/Users/J.Doe/Desktop/ProjetoProlog/tests/consultas_teste.pl'). 
consultas_teste.
```

Se todos os testes passarem, o console exibirá `Todos os testes passaram.`
