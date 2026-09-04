# 08 — Produtividade no shell: zsh, tmux e as ferramentas que valem o minuto

Esta página é **opcional**, e é a única do guia que é. Nada aqui entra no critério de aceite do
módulo: o `verificar-ambiente.sh` passa inteiro sem uma linha do que está escrito abaixo.

Ela existe por outro motivo. Depois do `07-docker.md` a sua máquina **funciona**; o que vem agora é
a diferença entre uma máquina que funciona e uma máquina em que dá gosto trabalhar — e essa
diferença se paga em minutos por dia, todo dia, pelo resto do catálogo.

> **O critério para uma ferramenta entrar nesta página:** ela tem que resolver um problema que você
> **já sentiu** nas sete páginas anteriores. Nenhuma está aqui porque é bonita. Se você ainda não
> sentiu o problema, pule o item — instalar ferramenta que resolve dor que você não tem é a forma
> mais rápida de terminar com um ambiente que você não entende.

---

## O que dói, e o que resolve

| A dor que você já sentiu | O que resolve |
|---|---|
| Digitou o comando errado três vezes e o shell não ajudou | **zsh** com autocompletar e correção |
| Não lembra do comando de ontem, e `history` tem 2000 linhas | **atuin** (`Ctrl-R`) ou **fzf** |
| Fechou o terminal e o `docker compose up` morreu junto | **tmux** |
| Não sabe em que branch está antes de rodar `git commit` | prompt com git (**spaceship** ou **starship**) |
| `cat` de arquivo grande vira parede de texto sem cor | **bat** |
| `cd ../../projetos/aethos/algumacoisa` toda vez | **zoxide** |
| Reinstalou a máquina e perdeu tudo que tinha configurado | **dotfiles** em repositório |

---

## 1. zsh + Oh My Zsh

O `bash` é o shell padrão do Ubuntu e não tem nada de errado com ele — todo comando deste guia roda
igual nos dois. O `zsh` ganha em três coisas concretas:

- **Autocompletar que entende o comando.** `git ch<Tab>` completa `checkout`; `docker compose <Tab>`
  lista os subcomandos de verdade, não os arquivos da pasta.
- **`cd` parcial.** `cd /u/l/b<Tab>` chega em `/usr/local/bin`.
- **Correção de digitação.** `gti status` pergunta se você quis dizer `git`.

```bash
sudo apt install -y zsh
zsh --version                      # confirme que instalou ANTES de trocar de shell
chsh -s "$(command -v zsh)"        # troca o shell padrão do seu usuário
```

🔴 **A troca só vale na PRÓXIMA sessão.** Rode `chsh`, feche o terminal, abra de novo, e confira com
`echo $SHELL`. Quem confere na mesma sessão vê `/bin/bash`, conclui que falhou, e roda `chsh` de
novo — mesma classe do `usermod -aG docker` do `05-ferramental.md`.

### Oh My Zsh

É um **framework de configuração** para o zsh: traz temas, plugins e um `~/.zshrc` já montado.
Não é o zsh; é uma camada em cima dele.

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Leia o que esse comando faz antes de rodar — é a regra 2 do README, e ela não tem exceção porque a
ferramenta é popular. Ele baixa um script e executa. O script está aberto na URL acima.

Dois plugins pagam a instalação sozinhos:

```bash
git clone https://github.com/zsh-users/zsh-autosuggestions \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting"
```

Depois, em `~/.zshrc`, a linha `plugins=(...)` — **a ordem importa**, o destaque de sintaxe por
**último**, senão ele não enxerga o que os outros definiram.

Esta é a linha que roda na máquina do instrutor, copiada do `~/.zshrc` e não inventada para o
material:

```bash
plugins=(autoenv git gitignore node npm zsh-autosuggestions vi-mode fast-syntax-highlighting)
```

`vi-mode` só entra se você já usa vi — senão é exatamente a ferramenta cuja dor você não tem.
`fast-syntax-highlighting` e `zsh-syntax-highlighting` resolvem o mesmo problema; o primeiro é mais
rápido em linha longa, e é o que está ligado aqui.

`source ~/.zshrc` para aplicar sem fechar o terminal.

| plugin | o que você vê |
|---|---|
| `zsh-autosuggestions` | o comando de ontem aparece em cinza enquanto você digita; `→` aceita |
| `fast-syntax-highlighting` | comando que existe fica verde, comando que não existe fica vermelho — **antes** de você apertar Enter |
| `git` | dezenas de atalhos (`gst`, `gco`, `glog`) e o branch no prompt |

> **Custo honesto:** Oh My Zsh carrega em toda abertura de terminal. Com muitos plugins, o shell
> demora a abrir. Medir, não achar:
> ```bash
> time zsh -i -c exit
> ```
> Acima de ~0,5 s, corte plugin. E meça de novo depois de cortar — corte sem segunda medição é
> palpite.

---

## 2. tmux — o terminal que sobrevive ao terminal

O problema que ele resolve é este: você sobe `docker compose up`, fecha a janela, e o processo morre
junto. Ou está conectado por SSH, a rede cai, e leva o trabalho embora.

O `tmux` põe uma **sessão** entre você e os processos. Fechar a janela desconecta você da sessão; a
sessão continua rodando.

```bash
sudo apt install -y tmux
```

Os seis comandos que resolvem 90% do uso. Tudo começa pelo **prefixo** — aperta, solta, e então a
tecla. O prefixo de fábrica é `Ctrl-b`; a configuração abaixo troca para `Ctrl-a`, e a tabela vale
para os dois: onde está `PREFIXO`, use o seu.

| o que você quer | como |
|---|---|
| criar sessão com nome | `tmux new -s agentia` |
| sair sem matar nada (*detach*) | `PREFIXO` `d` |
| voltar para ela | `tmux attach -t agentia` |
| ver o que está rodando | `tmux ls` |
| dividir a tela | `PREFIXO` `%` e `"` (ou `|` e `-`, com a config abaixo) |
| trocar de painel | `PREFIXO` seta |

**O uso que vale na aula:** um painel com o serviço rodando, outro com o log, outro com o shell
livre — e nada disso morre quando você fecha a janela para almoçar.

🔴 **`detach` não é `exit`.** `PREFIXO` `d` sai e **deixa rodando**; `exit` mata o painel. Quem confunde
os dois acha que o tmux "perdeu" a sessão. `tmux ls` responde qual dos dois aconteceu — se a sessão
está lá, você deu detach.

Uma configuração mínima em `~/.tmux.conf`, se a barra de status atrapalhar mais que ajudar:

```conf
unbind C-b
set-option -g prefix C-a     # C-b briga com vi/emacs; C-a não
set -g mouse on              # rolar e clicar no painel com o mouse
set -g base-index 1          # janelas começam em 1, não em 0
set -s escape-time 0         # Esc instantâneo no modo vi
set -g history-limit 50000
setw -g mode-keys vi

# as duas que mais pagam: painel novo abre no MESMO diretório
bind | split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"
bind r source-file ~/.tmux.conf \; display " Config reloaded"
```

🔴 **Trocar o prefixo é decisão, não melhoria universal.** `C-a` é o padrão do `screen` e não
conflita com o começo-de-linha do vi, mas conflita com o `Ctrl-a` do *bash* (que também é
começo-de-linha). Se você vive no bash sem vi-mode, `C-b` pode ser melhor para você. O que **não**
é opinião: painel que abre em `~` em vez de abrir onde você está custa um `cd` por painel, e você
abre dezenas por dia.

🔴 **Material da internet assume `C-b`**, e prefixo trocado é a causa nº 1 de "o atalho não
funciona". Antes de concluir que o tmux está quebrado, confira o seu prefixo:
`tmux show-options -g prefix`.

---

## 3. fzf — buscar em vez de lembrar

`fzf` é um filtro difuso interativo. Instalado, ele reescreve o `Ctrl-R` do shell: em vez de rolar o
histórico para trás, você digita pedaços do comando e ele filtra ao vivo.

```bash
sudo apt install -y fzf
```

No zsh, com Oh My Zsh, adicione `fzf` à lista de `plugins`. No bash:

```bash
# ~/.bashrc
source /usr/share/doc/fzf/examples/key-bindings.bash
```

**O que roda na máquina do instrutor é o `atuin`, não o `fzf`, para o `Ctrl-R`.** Ele guarda o
histórico em banco, com diretório e código de saída junto, então a busca é por contexto e não só
por texto:

```bash
bash <(curl https://raw.githubusercontent.com/atuinsh/atuin/main/install.sh)
echo 'eval "$(atuin init zsh --disable-up-arrow)"' >> ~/.zshrc
```

`--disable-up-arrow` é deliberado: seta para cima continua sendo o histórico local, que é o que o
dedo já sabe fazer. Sem essa flag, o atuin toma a seta também, e o gesto mais automático do shell
muda de comportamento sem aviso. O `fzf` continua valendo pelo `Ctrl-T` e `Alt-C`.

| atalho | o que faz |
|---|---|
| `Ctrl-R` | busca no histórico de comandos |
| `Ctrl-T` | busca um arquivo e cola o caminho na linha atual |
| `Alt-C` | busca uma pasta e entra nela |

Combina com o resto: `rg --files \| fzf` procura um arquivo entre todos do projeto.

---

## 4. Prompt: starship

Um prompt que diz **em que branch você está, se tem coisa não commitada, e qual versão de Node está
ativa** evita a classe de erro mais chata do módulo: rodar o comando certo no lugar errado.

```bash
curl -sS https://starship.rs/install.sh | sh
echo 'eval "$(starship init zsh)"' >> ~/.zshrc     # troque zsh por bash se for o caso
```

O starship é **independente do Oh My Zsh** — se usar os dois, deixe o tema do Oh My Zsh vazio
(`ZSH_THEME=""`) para não ter dois prompts brigando.

**Aqui roda `spaceship`, que é a outra escolha:** tema *do* Oh My Zsh, mesma informação no prompt,
instalado como tema em vez de binário separado. Os dois resolvem o mesmo problema e não se
somam — escolha um. `starship` é mais rápido e serve qualquer shell; `spaceship` já vem integrado
a quem usa Oh My Zsh.

> **Fonte.** Os ícones do prompt exigem uma *Nerd Font* instalada **no terminal do Windows**, não no
> Linux — quem desenha a letra é o Windows Terminal. Sem ela você vê quadradinhos. Instale uma
> (`FiraCode Nerd Font`, `JetBrainsMono Nerd Font`) e selecione em Configurações → Perfil → Aparência.
> Não quer mexer nisso? `starship preset no-nerd-font -o ~/.config/starship.toml` resolve.

---

## 5. Substitutos diretos, um comando cada

Estes você já viu no `05-ferramental.md`; aqui está o que muda quando você os torna o **padrão**.

```bash
sudo apt install -y bat eza fd-find ripgrep
```

No Ubuntu os binários do `bat` e do `fd` têm **outro nome** por conflito de pacote (`batcat`,
`fdfind`) — é a causa de "instalei e o comando não existe":

```bash
mkdir -p ~/.local/bin
ln -sf "$(command -v batcat)" ~/.local/bin/bat
ln -sf "$(command -v fdfind)" ~/.local/bin/fd
```

E os apelidos, no `~/.zshrc` (ou `~/.bashrc`):

```bash
alias ls='eza --group-directories-first'
alias ll='eza -la --git'
alias cat='bat --paging=never'
```

🔴 **Apelidar `cat` tem um custo real.** Apelido só vale para você digitando; script continua usando
o `cat` de verdade. Mas quando você **copia uma saída** de um `cat` apelidado, ela vem com número de
linha e cor — e colar isso num chat ou num prompt de IA leva lixo junto. Sabendo do custo, a decisão
é sua. Na dúvida, apelide para `c` e deixe o `cat` em paz.

### zoxide — `cd` que aprende

```bash
sudo apt install -y zoxide
echo 'eval "$(zoxide init zsh)"' >> ~/.zshrc
```

Depois de visitar uma pasta uma vez, `z agentia` te leva lá de qualquer lugar. Ele ranqueia por
frequência e recência, então acerta mais quanto mais você usa.

---

## 6. Dotfiles: o passo que faz tudo acima sobreviver

Tudo desta página mora em arquivos de configuração — `~/.zshrc`, `~/.tmux.conf`,
`~/.config/starship.toml`, `~/.gitconfig`. Reinstalar a máquina sem eles versionados significa
refazer esta página inteira de memória, e a memória não guarda o motivo de cada linha.

```bash
mkdir -p ~/dotfiles && cd ~/dotfiles
git init
cp ~/.zshrc ~/.tmux.conf .
git add . && git commit -m "chore: primeira leva de dotfiles"
```

Depois, na máquina nova, **link simbólico em vez de cópia** — assim editar o arquivo edita o
repositório, e não existem duas versões divergindo:

```bash
ln -sf ~/dotfiles/.zshrc ~/.zshrc
```

🔴 **Dotfile é onde segredo vaza sem ninguém decidir.** `~/.zshrc` com um `export OPENAI_API_KEY=...`
dentro, versionado num repositório público, é exatamente o exercício do dia 3 — só que com um
segredo seu, de verdade. Antes do primeiro commit:

```bash
grep -rniE '(key|token|secret|password|senha)[[:space:]]*=' ~/dotfiles
```

Achou alguma coisa? Tire do dotfile e ponha num `~/.zshrc.local` **fora** do repositório, carregado
no fim do `~/.zshrc`:

```bash
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
```

E se o `grep` acima devolveu zero, confira que ele não está cego antes de acreditar: rode o mesmo
comando contra uma linha que você **sabe** que existe (`grep -c alias ~/dotfiles/.zshrc`). Zero sem
um positivo ao lado é indistinguível de busca quebrada — a regra vale aqui e vale no resto do curso.

---

## Pronto para o próximo

Nada aqui é obrigatório, então o checklist é de **entendimento**, não de instalação:

- [ ] `echo $SHELL` mostra o shell que você escolheu, numa sessão nova
- [ ] Você sabe sair de uma sessão tmux **sem** matar o que está rodando
- [ ] `Ctrl-R` filtra o histórico enquanto você digita
- [ ] Seus arquivos de configuração estão em um repositório, e ele não tem segredo dentro

Travou em algum passo? [`PROBLEMAS.md`](PROBLEMAS.md). Palavra nova? [`GLOSSARIO.md`](GLOSSARIO.md).
Quer ir mais fundo em qualquer uma destas ferramentas? [`REFERENCIAS.md`](REFERENCIAS.md).
