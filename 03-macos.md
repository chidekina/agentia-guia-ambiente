# 03 — macOS

**Tempo:** 30-45 min.
**Ao final:** o terminal do mac com as ferramentas do curso, e você sabendo onde o mac **difere**
do Linux — que é a parte que morde.

---

## Primeiro, a verdade: macOS não é Linux

E também não é "quase Linux". Os dois descendem da mesma ideia — Unix — mas por caminhos
diferentes:

|  | Linux | macOS |
|---|---|---|
| Kernel | Linux, escrito do zero em 1991 | **XNU** = Mach + código BSD |
| Parentesco com Unix | inspirado, sem código de Unix | descende de Unix de verdade, via NeXTSTEP |
| Certificação | não é UNIX certificado | **é UNIX certificado** (Open Group) |
| Ferramentas de linha (`ls`, `sed`, `date`) | **GNU** | **BSD** |

A última linha é a que custa tempo, e ela é o assunto principal desta página.

Para o Módulo 0, o mac **é aceito**: o shell é próximo o suficiente e o `verificar-ambiente.sh`
reconhece o Darwin. Mas saiba desde já que produção é Linux, e o que passa aqui pode falhar lá.

---

## Passo 1 — Ferramentas de linha de comando da Apple

```bash
xcode-select --install
```

Abre uma janela, pede confirmação, baixa alguns GB. Isso traz compilador, `git` e o básico.
Se disser que já está instalado, ótimo, siga.

---

## Passo 2 — Homebrew

O macOS **não tem** gerenciador de pacote próprio para ferramenta de linha de comando. O Homebrew
é de terceiros, e é o padrão de fato:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Ao final ele imprime **duas ou três linhas para você colar**, que colocam o `brew` no `PATH`.
Cole-as. Em Mac com Apple Silicon, elas se parecem com:

```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

Confira:

```bash
brew --version
```

> **Por que o mac tem três caminhos de instalação convivendo** (`brew`, App Store, `.dmg`
> arrastado à mão) e o Linux tem um só: no Linux o gerenciador de pacote é **do sistema**, e um
> comando só atualiza tudo. Aqui, cada app cuida de si. Não é melhor nem pior — é diferente, e
> muda como você mantém a máquina.

---

## Passo 3 — A parte que evita dor: ferramentas GNU

Este é o passo que a maioria dos tutoriais de mac não menciona, e é o que separa "meu script
funciona" de "meu script funciona **e** também em produção".

**O problema:** o mac traz as ferramentas **BSD**. Elas têm o mesmo nome das GNU e **flags
diferentes**. O comando existe, aceita o argumento, e faz outra coisa — ou recusa.

| Tarefa | Linux (GNU) | macOS (BSD) |
|---|---|---|
| Editar arquivo no lugar | `sed -i 's/a/b/' f` | `sed -i '' 's/a/b/' f` — exige o argumento vazio |
| Data relativa | `date -d '1 day ago'` | `date -v-1d` — `-d` **não existe** |
| Caminho absoluto resolvido | `readlink -f caminho` | **não existe** |
| Base64 sem quebra de linha | `base64 -w0` | `-w` não existe; já é o padrão |
| `grep` estendido | `grep -P` (Perl) | não existe |

**Instale as GNU ao lado:**

```bash
brew install coreutils findutils gnu-sed grep gawk
```

Por padrão elas ganham prefixo `g` (`gsed`, `gdate`, `greadlink`). Para que os nomes normais
apontem para as GNU, acrescente ao seu `~/.zshrc`:

```bash
# ferramentas GNU antes das BSD, para o comportamento bater com o de produção
export PATH="$(brew --prefix)/opt/coreutils/libexec/gnubin:$PATH"
export PATH="$(brew --prefix)/opt/gnu-sed/libexec/gnubin:$PATH"
export PATH="$(brew --prefix)/opt/grep/libexec/gnubin:$PATH"
```

Recarregue com `source ~/.zshrc` e confira — a resposta tem de mencionar **GNU**:

```bash
sed --version | head -1
date --version | head -1
```

---

## Passo 4 — A armadilha que não tem conserto por instalação

O sistema de arquivos padrão do mac, **APFS, não diferencia maiúscula de minúscula**. O Linux
diferencia. Isso produz o bug mais frustrante da carreira de muita gente:

```
arquivo no disco:   src/components/Button.tsx
no código:          import Button from './components/button'

macOS   → funciona     (não diferencia)
Windows → funciona     (não diferencia)
Linux   → ERRO         Module not found: './components/button'
```

E o CI é Linux. E a produção é Linux. **O erro só aparece depois do push, numa máquina que não é
a sua** — que é a definição de bug caro.

Não há instalação que resolva. O que resolve é hábito:

- Escreva o import com a **mesma caixa** do arquivo, sempre.
- Renomeou um arquivo só trocando a caixa? O Git no mac pode não perceber. Use
  `git mv arquivo.txt Arquivo.txt` em duas etapas (`git mv a.txt tmp && git mv tmp A.txt`).
- Antes de abrir PR, confie no CI mais do que na sua máquina.

---

## Passo 5 — Docker

```bash
brew install --cask docker
```

Abra o Docker Desktop uma vez pelo Launchpad e deixe terminar a configuração inicial. Confira:

```bash
docker --version
docker run --rm hello-world
```

Lembre do que está acontecendo por baixo: **no mac, container roda dentro de uma máquina
virtual.** É por isso que o Docker Desktop consome memória visível e que pasta compartilhada com
o container é mais lenta que no Linux. Mesma família de custo que o `/mnt/c` do WSL.

---

## Pronto para o próximo

- [ ] `brew --version` responde
- [ ] `sed --version` menciona **GNU**
- [ ] `docker run --rm hello-world` funciona
- [ ] Você sabe por que `import './button'` pode passar aqui e quebrar no CI

→ [`04-primeiros-passos-shell.md`](04-primeiros-passos-shell.md)
