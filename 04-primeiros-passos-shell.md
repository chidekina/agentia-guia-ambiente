# 04 — Primeiros passos no shell

**Tempo:** 30 min lendo e digitando. Digite, não copie — a memória está nos dedos.
**Ao final:** você se move pelo sistema, lê arquivo, combina comandos e sabe onde procurar
resposta antes de perguntar.

---

## Por que o shell parece cru

Não é descuido de design: é a filosofia do Unix, de 1969. Programas pequenos, cada um fazendo uma
coisa, que se combinam **por texto**. O texto é a interface, e o texto compõe.

É por isso que existe o `|` (pipe). E é por isso que, depois que você entende cinco comandos, você
consegue coisas que nenhum menu oferece — porque você não está escolhendo de uma lista, está
montando.

---

## Onde estou, o que tem aqui

```bash
pwd              # print working directory — o caminho onde você está
ls               # lista
ls -la           # lista TUDO, inclusive arquivo oculto, com detalhe
cd ~             # vai para a sua casa
cd /             # vai para a raiz do sistema
cd ..            # sobe um nível
cd -             # volta para onde você estava antes
```

Duas coisas que economizam muito tempo, agora:

- **Tab completa.** Digite `cd ~/pro` e aperte `Tab`. Ele completa. Aperte duas vezes para ver as
  opções. Você vai usar isso mil vezes por dia.
- **Seta para cima** repete o comando anterior. `Ctrl+R` procura no histórico: aperte, digite um
  pedaço do comando, ele acha.

### Lendo o `ls -la`

```
drwxr-xr-x  4 cesar cesar 4096 Aug 28 11:20 projetos
-rw-r--r--  1 cesar cesar  220 Aug 28 09:03 .bashrc
^^^^^^^^^^    ^^^^^ ^^^^^                   ^^^^^^^^
│││└┴┴─ outros       │     └ grupo dono      └ nome (o . na frente = oculto)
││└┴┴── grupo        └ usuário dono
│└┴┴─── dono
└ d = diretório, - = arquivo, l = link
```

`rwx` é **r**ead, **w**rite, e**x**ecute. Um `.sh` só roda se tiver o `x`.

---

## A árvore do sistema

Diferente do Windows, **não há letra de unidade**. Tudo pendura de uma raiz só, `/`:

| Caminho | O que é |
|---|---|
| `/home/voce` (ou `~`) | sua casa. **É aqui que seus projetos moram** |
| `/etc` | configuração do sistema |
| `/usr/bin`, `/bin` | os programas |
| `/var/log` | logs |
| `/tmp` | temporário, some no reboot |
| `/proc`, `/sys` | o kernel exposto como se fosse arquivo |
| `/mnt/c` | **só no WSL** — o disco C: do Windows. Não guarde projeto aqui |

Um disco externo, um pendrive ou outra partição não vira `D:`, vira uma **pasta** dentro dessa
árvore (normalmente em `/mnt` ou `/media`).

---

## Ler e criar arquivo

```bash
cat arquivo.txt          # despeja o conteúdo inteiro
less arquivo.txt         # abre paginado — `q` para sair, `/` para buscar
head -20 arquivo.txt     # as 20 primeiras linhas
tail -20 arquivo.txt     # as 20 últimas
tail -f app.log          # acompanha o arquivo AO VIVO. Ctrl+C para sair

touch novo.txt           # cria vazio
mkdir -p a/b/c           # cria a árvore inteira de pastas
cp origem destino        # copia
mv origem destino        # move — e é também como se renomeia
rm arquivo               # apaga. NÃO vai para lixeira. Não tem undo
rm -rf pasta             # apaga pasta e tudo dentro. Leia duas vezes antes
```

> `rm -rf` é definitivo e silencioso. Antes de rodar num caminho montado por variável, rode o
> `ls` no mesmo caminho primeiro e **olhe a lista**.

---

## Combinar: pipe e redirecionamento

Aqui mora a ideia toda.

```bash
cat arquivo.txt | grep erro          # só as linhas que contêm "erro"
ls -la | grep '\.md$'                # só os arquivos que terminam em .md
ps aux | grep node                   # os processos do node

ls -la > lista.txt                   # joga a saída num arquivo (sobrescreve)
echo "mais uma linha" >> lista.txt   # acrescenta ao fim
comando 2> erros.txt                 # redireciona só os ERROS
comando > saida.txt 2>&1             # tudo junto no mesmo arquivo
```

`|` liga a saída de um à entrada do outro. `>` escreve em arquivo. É só isso — e com isso você
monta praticamente qualquer coisa.

Um exemplo real, que você vai usar:

```bash
grep -rn "TODO" src/ | wc -l         # quantos TODO existem no projeto
```

`grep -rn` procura recursivo mostrando a linha; `wc -l` conta linhas. Dois programas simples,
uma resposta que nenhum dos dois dá sozinho.

---

## Procurar

```bash
grep -rn "termo" .                 # procura dentro dos arquivos, recursivo
rg "termo"                         # ripgrep: o mesmo, muito mais rápido
find . -name "*.md"                # procura por NOME de arquivo
find . -name "*.log" -delete       # acha e apaga (cuidado)
```

**`grep` procura dentro; `find` procura o nome.** Confundir os dois é rito de passagem.

---

## Variáveis de ambiente

```bash
echo $HOME              # o caminho da sua casa
echo $PATH              # onde o shell procura os programas
export FOO=bar          # define para esta sessão
env                     # lista todas
env | grep -i proxy     # procura uma
```

`PATH` explica um erro comum: `command not found` quase sempre significa "o programa existe, mas
não está numa pasta do `PATH`", e não "não está instalado".

Variável definida com `export` **some quando você fecha o terminal**. Para durar, ela vai no
`~/.bashrc` (bash) ou `~/.zshrc` (zsh).

---

## Processos

```bash
ps aux | grep node       # o que está rodando
top                      # ao vivo. `q` sai
htop                     # a versão boa: sudo apt install -y htop
kill 1234                # pede para o processo 1234 terminar
kill -9 1234             # força. Último recurso
Ctrl+C                   # interrompe o que está rodando na sua frente
Ctrl+Z  e  bg            # suspende e joga para segundo plano
jobs                     # o que está em segundo plano nesta sessão
```

> **Um `kill` que retorna sem erro não prova que o processo morreu.** Confira com `ps` depois.
> Vale a regra geral: o código de saída atesta que a **chamada** foi aceita, não que o **efeito**
> aconteceu.

---

## Onde procurar antes de perguntar

```bash
man ls                   # o manual completo. `q` sai, `/` busca dentro
ls --help                # a versão curta, geralmente cabe na tela
tldr ls                  # exemplos práticos:  sudo apt install -y tldr
which git                # onde está o programa que vai rodar
type cd                  # o que é isso, afinal (comando, alias, função?)
```

`man` é denso de propósito — é referência, não tutorial. `--help` costuma bastar.

---

## Os 12 que resolvem o dia

Se você decorar só isto, está bem servido:

```
pwd  ls  cd  cat  less  grep  find  cp  mv  rm  ps  man
```

E dois hábitos que valem mais que qualquer comando: **`Tab` para completar** e **ler a mensagem
de erro inteira**.

---

## Pratique agora (5 min)

```bash
mkdir -p ~/lab/teste && cd ~/lab/teste
echo "primeira linha" > a.txt
echo "segunda linha com erro" >> a.txt
cat a.txt
grep erro a.txt
ls -la > listagem.txt && cat listagem.txt
wc -l a.txt
cd ~ && rm -rf ~/lab
```

Cada linha aí usa uma coisa desta página. Se todas responderam o que você esperava, siga.

→ [`05-ferramental.md`](05-ferramental.md)
