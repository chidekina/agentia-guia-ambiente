# 06 — Git e GitHub

**Tempo:** 20-30 min.
**Ao final:** identidade configurada, chave SSH funcionando, e você entendendo por que
`git rm` **não** apaga o passado — que é a armadilha do módulo.

---

## Identidade

O Git assina cada commit com nome e e-mail. Configure antes do primeiro commit, senão você
descobre depois que o histórico está assinado por `ubuntu@DESKTOP-XYZ`.

```bash
git config --global user.name "Seu Nome"
git config --global user.email "seu@email.com"
git config --global init.defaultBranch main
git config --global core.autocrlf input        # ver nota abaixo
git config --global pull.rebase false

git config --global --list                     # confira
```

**`core.autocrlf input`** é o que evita o `bad interpreter: /bin/bash^M` do
[`PROBLEMAS.md`](PROBLEMAS.md). Ele diz: converta `CRLF` para `LF` ao commitar, e não mexa na
volta. É o valor certo para quem trabalha no Linux/WSL.

Use **o mesmo e-mail da sua conta do GitHub**, senão os commits não aparecem vinculados ao seu
perfil.

---

## Chave SSH

HTTPS pede senha (token) a cada operação. SSH resolve de uma vez.

```bash
ssh-keygen -t ed25519 -C "seu@email.com"
```

Três perguntas:

- **Caminho do arquivo** — aperte Enter, o padrão está certo (`~/.ssh/id_ed25519`).
- **Passphrase** — pode deixar vazia. Com passphrase é mais seguro e pede senha ao usar; o
  `ssh-agent` abaixo guarda por sessão.
- Confirmação da passphrase.

Ligue o agente e adicione a chave:

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

Copie a chave **pública** (a que termina em `.pub` — a outra **nunca** sai da sua máquina):

```bash
cat ~/.ssh/id_ed25519.pub
```

Cole em **GitHub → Settings → SSH and GPG keys → New SSH key**. Teste:

```bash
ssh -T git@github.com
```

A resposta esperada é `Hi seu-usuario! You've successfully authenticated...`. Ela diz
`does not provide shell access` logo depois — isso é normal, não é erro.

> 🔴 **A chave SSH tem de estar dentro do Linux, em `~/.ssh`.** Nunca em `/mnt/c`. Permissão não
> atravessa a fronteira do WSL: o arquivo aparece como `777`, o `ssh` recusa por "permissão frouxa
> demais", e nenhum `chmod 600` resolve enquanto o arquivo estiver lá.

Se precisar corrigir permissão da sua `~/.ssh`:

```bash
chmod 700 ~/.ssh && chmod 600 ~/.ssh/id_ed25519 && chmod 644 ~/.ssh/id_ed25519.pub
```

---

## `gh` autenticado

```bash
gh auth login
```

Escolha `GitHub.com` → `SSH` → a chave que você acabou de criar → `Login with a web browser`.
Ele mostra um código, abre o navegador, você cola. Confira:

```bash
gh auth status
```

---

## O ciclo que você vai repetir o curso inteiro

```bash
git clone git@github.com:usuario/repo.git    # baixa (SSH, não HTTPS)
cd repo

git status                    # o que mudou — rode isto o tempo todo
git diff                      # o que exatamente mudou, linha a linha
git add arquivo.txt           # marca este arquivo para o próximo commit
git add -p                    # marca PEDAÇO por pedaço, e mostra cada um
git commit -m "mensagem"      # grava
git log --oneline             # o histórico compacto
git push                      # envia
git pull                      # traz o que mudou no remoto
```

**Dois hábitos que os instrutores vão cobrar:**

1. **`git status` antes de qualquer coisa.** Metade dos problemas de git é não saber em que estado
   a árvore está. Teste falhando logo depois de um `checkout` merece um `git status` **antes** de
   você investigar o código — o problema costuma ser o ambiente, não a lógica.
2. **Commit de assunto único.** Um commit que muda três assuntos não pode ser revertido sem levar
   os outros dois junto. Se você precisa escrever "e também" na mensagem, são dois commits.

---

## Branch e PR, o básico

```bash
git switch -c feat/minha-mudanca     # cria e entra numa branch nova
# ...trabalha, commita...
git push -u origin HEAD              # PRIMEIRO push da branch precisa do -u
gh pr create                         # abre o PR pela linha de comando
gh pr view --web                     # abre no navegador
```

O `-u` no primeiro push é o que liga a sua branch local à remota. Sem ele, `git push` pelado
falha com uma mensagem longa que ninguém lê até a terceira vez.

---

## A armadilha do módulo: `git rm` não apaga o passado

Este é o exercício do dia 3, e vale entender antes.

Suponha que você commitou um `.env` com uma chave de API. Percebeu, e fez o óbvio:

```bash
git rm --cached .env
echo ".env" >> .gitignore
git commit -m "remove .env"
```

**O arquivo saiu do próximo commit. O segredo continua no histórico.** Qualquer pessoa com o
repositório recupera o valor com um comando:

```bash
git log -p | grep -i "API_KEY"        # e lá está ele
git log --all --full-history -- .env  # todos os commits que tocaram o arquivo
```

Git é um histórico **imutável por desenho**: um commit novo não desfaz um antigo, ele acrescenta.

**O que fazer de verdade, na ordem certa:**

1. **Rotacione o segredo primeiro.** Invalide a chave vazada e gere outra. Isso é a parte que
   realmente protege; o resto é limpeza. Uma chave que vazou está vazada mesmo que você limpe o
   histórico — assuma que foi lida.
2. **Depois** reescreva o histórico, com `git filter-repo` (recomendado) ou BFG Repo-Cleaner.
3. **Previna:** `.env` no `.gitignore` desde o primeiro commit, e um `.env.example` versionado com
   as **chaves** e sem os **valores**.

Você vai praticar isso na semente do módulo, que já vem com o defeito plantado — inclusive uma
chave que aparece rotacionada no meio do histórico, para você descobrir que remover a última
ocorrência não basta.

> **Regra que fica:** segredo não entra no Git. Nem uma vez, nem "só para testar", nem em branch
> que você vai apagar. O custo de prevenir é uma linha no `.gitignore`; o de corrigir é reescrever
> histórico e avisar todo mundo que clonou.

---

## Pronto para o próximo

- [ ] `git config --global --list` mostra seu nome e e-mail
- [ ] `ssh -T git@github.com` responde com o seu usuário
- [ ] `gh auth status` diz autenticado
- [ ] Você sabe explicar por que `git rm` não resolve um segredo vazado

→ [`07-docker.md`](07-docker.md)
