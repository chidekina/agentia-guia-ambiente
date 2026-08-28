# 05 — Ferramental

**Tempo:** 30-40 min, contando download.
**Ao final:** git, Docker, Node por `nvm`, `gh`, `jq` e `ripgrep` instalados — e você sabendo
**por que** cada um está na lista.

A lista não é preferência pessoal. Cada item é exigido por alguma imersão do catálogo, e está
anotado aqui de onde vem.

| Ferramenta | Por que está aqui |
|---|---|
| `git` | Toda imersão entrega artefato em repositório |
| `docker` + `docker compose` | Banco, fila e serviço de apoio das imersões sobem por aqui |
| Node LTS via `nvm` | Versão fixada por projeto — `apt install nodejs` dá versão velha e presa |
| `gh` (GitHub CLI) | PR e review pela linha de comando, a partir da imersão 16 |
| `jq` | Ler saída JSON de API sem abrir editor |
| `ripgrep` (`rg`) | Busca em base grande; substitui `grep -r` no dia a dia |
| VS Code + extensão WSL | O editor roda no host, os arquivos ficam no Linux |

---

## Tudo de uma vez (Ubuntu / Debian / Mint)

```bash
sudo apt update
sudo apt install -y build-essential curl git jq ripgrep unzip
```

Outra distro? A tabela de tradução está em [`02-linux-nativo.md`](02-linux-nativo.md#a-tabela-de-tradução).
macOS? Troque por `brew install`.

---

## Docker

```bash
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER
```

> **O `usermod` não tem efeito na sessão que está aberta.** Grupo de usuário é lido no login.
> **Feche o terminal e abra de novo** — no WSL, `wsl --shutdown` no PowerShell e reabrir o Ubuntu.
> Pular este passo é o motivo nº 1 de "instalei o Docker e dá permission denied".

Confira as duas coisas separadamente, porque elas falham por motivos diferentes:

```bash
docker --version     # o binário existe
docker info          # o daemon responde E você tem permissão
docker run --rm hello-world
```

Se `docker --version` responde mas `docker info` dá `permission denied`, é o grupo — reabra o
shell. Se der `Cannot connect to the Docker daemon`, o serviço não está de pé:

```bash
sudo service docker start        # WSL
sudo systemctl start docker      # Linux nativo com systemd
```

---

## Node, pelo `nvm` (e não pelo `apt`)

**Por que não `apt install nodejs`:** ele instala uma versão antiga, presa à distribuição, e
global. Projeto diferente pede versão diferente de Node, e você vai precisar trocar.

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
```

**Feche e reabra o terminal** (o instalador acrescenta linhas ao seu `~/.bashrc`). Depois:

```bash
nvm install --lts        # instala a LTS atual
nvm use --lts
node --version
npm --version
```

No dia a dia:

```bash
nvm ls                   # o que você tem instalado
nvm install 20           # uma versão específica
nvm use 20               # troca nesta sessão
nvm alias default 20     # define o padrão de toda sessão nova
```

Um projeto com arquivo `.nvmrc` na raiz responde só a `nvm use`, sem argumento — ele lê o arquivo.

---

## GitHub CLI (`gh`)

```bash
sudo apt install -y gh
```

Se a sua distribuição não tiver o pacote, o repositório oficial e os instaladores estão em
<https://cli.github.com>. A autenticação fica no [`06-git-e-github.md`](06-git-e-github.md).

---

## Editor

**No WSL:** o VS Code é instalado **no Windows**, com a extensão **WSL**. Detalhado no
[`01-windows-wsl2.md`](01-windows-wsl2.md#passo-4--o-editor).

**No Linux nativo:**

```bash
sudo snap install code --classic
# ou baixe o .deb em https://code.visualstudio.com
```

**No macOS:** `brew install --cask visual-studio-code`.

Extensões que valem para o curso: **WSL** (obrigatória no Windows), **Docker**, **ESLint**,
**GitLens**.

---

## Coisas pequenas que melhoram muito o dia

Nenhuma é obrigatória. Todas cabem em um comando.

```bash
sudo apt install -y htop tree tldr bat fd-find
```

| Ferramenta | O que faz |
|---|---|
| `htop` | `top` legível, com cores e navegação |
| `tree` | mostra a árvore de pastas de uma vez |
| `tldr` | exemplos práticos de um comando, sem a densidade do `man` |
| `bat` | `cat` com cor de sintaxe e número de linha |
| `fd` | `find` com sintaxe humana (no Ubuntu o binário chama `fdfind`) |

---

## Confira tudo de uma vez

```bash
for c in git docker node npm gh jq rg; do
  if command -v "$c" >/dev/null 2>&1; then echo "ok    $c  $($c --version 2>&1 | head -1)"
  else echo "FALTA $c"; fi
done
docker info >/dev/null 2>&1 && echo "ok    docker daemon" || echo "FALTA docker daemon (grupo? serviço?)"
```

Repare que a última linha checa o **daemon** separado do **binário**: são duas falhas diferentes,
com dois consertos diferentes, e um teste que juntasse as duas não diria qual delas aconteceu.

---

## Pronto para o próximo

- [ ] Todos os 7 dizem `ok` na checagem acima
- [ ] `docker run --rm hello-world` funciona **sem `sudo`**
- [ ] `node --version` mostra uma LTS (número par: 20, 22, 24…)
- [ ] O editor abre a pasta do Linux

→ [`06-git-e-github.md`](06-git-e-github.md)
