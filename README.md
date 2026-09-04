# Guia de ambiente — Agentia, Módulo 0

Passo a passo para você chegar na primeira imersão com a máquina **funcionando**, em vez de
perder a semana 1 instalando coisa.

Este guia acompanha o **Módulo 0 — Linux, WSL e ambiente** (gratuito, 3 encontros de 2h). Ele
existe para ser lido **fora** da aula: na aula você instala, aqui você consulta.

---

## O que você terá ao final

Um shell Linux que abre e responde, com git, Docker, Node, `gh` e `jq` instalados, e um
repositório que clona e roda. Nada disso é opinião — tem um script que mede, e ele diz
exatamente qual item falta.

**O critério de pronto do módulo, sem rodeio:**

1. O script de verificação passa inteiro.
2. `git log -p` não contém o segredo em nenhum commit.
3. O repositório clona e roda seguindo o README.

Os itens 2 e 3 são o exercício do dia 3, e vêm com a semente. O item 1 é o que este guia entrega.

---

## Por onde começar

**Escolha um caminho e não mude no meio.** Trocar de caminho na metade é a forma mais rápida de
terminar o módulo com duas instalações pela metade e nenhuma funcionando.

| Você usa | Vá para | Tempo |
|---|---|---|
| **Windows** | [`01-windows-wsl2.md`](01-windows-wsl2.md) | 40-60 min |
| **Linux** já instalado | [`02-linux-nativo.md`](02-linux-nativo.md) | 15-30 min |
| **macOS** | [`03-macos.md`](03-macos.md) | 30-45 min |

Depois, **todo mundo faz os mesmos quatro**, na ordem:

1. [`04-primeiros-passos-shell.md`](04-primeiros-passos-shell.md) — os 12 comandos que resolvem 90% do dia
2. [`05-ferramental.md`](05-ferramental.md) — git, Docker, Node por `nvm`, `gh`, `jq`, `ripgrep`, editor
3. [`06-git-e-github.md`](06-git-e-github.md) — identidade, chave SSH, primeiro clone
4. [`07-docker.md`](07-docker.md) — subir um banco e conversar com ele

Terminou os quatro? A máquina está pronta e o módulo está cumprido. O quinto é **opcional** e não
entra em critério nenhum:

5. [`08-produtividade-shell.md`](08-produtividade-shell.md) — zsh, tmux, fzf e as ferramentas que
   você só instala depois de ter sentido a dor que cada uma resolve

Travou? [`PROBLEMAS.md`](PROBLEMAS.md) é sintoma → causa → ação, e cobre as falhas que aparecem
de verdade. Palavra que você não conhece? [`GLOSSARIO.md`](GLOSSARIO.md).
Quer ir além? [`REFERENCIAS.md`](REFERENCIAS.md).

---

## Como este guia trata erro

**Erro não é fracasso, é dado.** Você vai errar em algum passo — todo mundo erra, e os erros são
os mesmos há vinte anos. O que separa quem resolve em 5 min de quem perde a tarde é uma coisa só:

> **Ler a mensagem inteira, e copiar em vez de descrever.**

“Deu erro no WSL” não tem conserto. `WslRegisterDistribution failed: 0x80370102` tem conserto,
está no [`PROBLEMAS.md`](PROBLEMAS.md), e leva 2 minutos.

Quando pedir ajuda no chat da turma, mande três coisas:

```
1. o comando que você rodou   (copiado, não digitado de novo)
2. a mensagem inteira          (copiada, não resumida)
3. o que você já tentou
```

---

## Checagem rápida, a qualquer momento

Cole no terminal do Linux. Não é o instrumento oficial — é um cartão de resposta rápida:

```bash
for c in git docker node npm gh jq rg; do
  if command -v "$c" >/dev/null 2>&1; then echo "ok    $c  $($c --version 2>&1 | head -1)"
  else echo "FALTA $c"; fi
done
```

**O instrumento oficial é o `verificar-ambiente.sh`**, que vem dentro do repositório da semente
que você clona no dia 2. Ele checa mais coisa que a lista acima — inclusive se o seu projeto está
no lugar errado do disco. Para rodar só a parte de ambiente, sem as checagens de repositório:

```bash
PULAR_REPO=1 bash verificar-ambiente.sh
```

Ele sai `0` quando tudo passa e `1` quando falta alguma coisa, e **nomeia o que falta com a ação
que resolve**. Item vermelho não é bronca: é a sua lista de tarefas.

---

## Três regras que valem para o módulo inteiro

**1. O projeto mora dentro do Linux.**
No WSL, `~` (a sua casa no Ubuntu). **Nunca** em `/mnt/c`. O motivo está no
[`01-windows-wsl2.md`](01-windows-wsl2.md#a-regra-que-vale-para-o-curso-inteiro), e ele é medido,
não opinião.

**2. Leia o comando antes de dar `sudo`.**
`sudo` é a fronteira entre "quebrei uma pasta" e "reinstalo o sistema". Não existe "tem certeza?".
Comando copiado da internet com `sudo` na frente merece dez segundos de leitura.

**3. Segredo não entra no Git.**
Nem uma vez, nem "só para testar". Remover o arquivo depois **não** remove o passado — e essa é
exatamente a armadilha que o exercício do módulo planta para você descobrir na prática.

---

## Este guia está errado em algum ponto?

Ótimo — é a coisa mais útil que você pode trazer para a turma. Abra uma issue, mande no chat, ou
traga no dia 2 com o comando e a mensagem. Guia de instalação apodrece rápido: versão nova de
Ubuntu, o instalador muda, um passo deixa de existir. Quem encontrar primeiro conserta para todo
mundo.

---

## Slides do encontro

A apresentação do **Dia 1 — "Por que Linux, e a máquina de pé"**, nos dois formatos, está em [**Releases → v1.0-modulo-0**](https://github.com/chidekina/agentia-guia-ambiente/releases/tag/v1.0-modulo-0):

- `modulo-0-dia-1-linux-wsl.pdf` — para ler offline ou imprimir
- `modulo-0-dia-1-linux-wsl.html` — abre no navegador, é o que roda na aula

Os slides ficam no release e não na árvore do repositório de propósito: são 2,2 MB (quase tudo
fontes embutidas, para o deck funcionar sem internet na sala) contra 36 KB de guia. Na árvore, todo
aluno que clonasse baixaria os 2,2 MB para sempre, inclusive quem só quer as páginas.

A apresentação do **Dia 2 — "Ambiente controlado, ferramentas e as armadilhas do WSL"** está em
[**Releases → v1.1-modulo-0-dia-2**](https://github.com/chidekina/agentia-guia-ambiente/releases/tag/v1.1-modulo-0-dia-2):

- `modulo-0-dia-2-ferramentas-ambiente.pdf`
- `modulo-0-dia-2-ferramentas-ambiente.html`

O bloco **2b** desse deck é a página [`08-produtividade-shell.md`](08-produtividade-shell.md), a
única opcional do guia.

O slide **não substitui o guia**. Ele dá o porquê e a ordem; os comandos exatos, com o que fazer
quando quebram, estão nas páginas numeradas acima. Na aula seguimos o guia — o slide é o fio.

---

## Licença

O material didático deste repositório (todas as páginas `.md`, os slides e o glossário) está sob
**[CC BY-SA 4.0](LICENSE)**: pode usar, adaptar e redistribuir, inclusive comercialmente, desde que
**dê crédito** e **mantenha a mesma licença** no que derivar.

O script `verificar-links.sh` é código, e fica sob **[MIT](LICENSE-CODE)** — use como quiser, sem obrigação de
compartilhar igual.

Em resumo: leve o guia para a sua turma. Se melhorar, deixe a melhoria aberta do mesmo jeito.
