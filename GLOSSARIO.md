# Glossário

As palavras que aparecem no módulo, na ordem em que confundem.

---

## Sistema

**Kernel** — o núcleo do sistema. Fala com o hardware e arbitra memória, processo e disco. Linux,
NT (Windows) e XNU (macOS) são três kernels diferentes.

**Userland** — tudo que não é kernel: `ls`, `cp`, `grep`, o shell. Vem do **GNU** no Linux, do
**BSD** no macOS, do Win32/PowerShell no Windows. **Quase toda incompatibilidade que você vai
encontrar é aqui**, não no kernel: o mesmo nome de comando, escrito por projetos diferentes, com
flags diferentes.

**GNU/Linux** — o nome completo, e ele explica a estrutura: o kernel (Linux, 1991) e o userland
(GNU, 1983) são projetos separados que vieram de lugares diferentes.

**POSIX** — o padrão que diz como um sistema tipo Unix deve se comportar. Linux é
POSIX-compatível na prática; macOS é **UNIX certificado** de verdade; Windows só por camada (WSL).

**Distribuição (distro)** — kernel + userland + gerenciador de pacote + política de release +
ambiente gráfico, empacotados. **O kernel é praticamente o mesmo em todas**; o que muda é o resto.

**Shell** — o programa que lê o que você digita e executa. `bash` é o padrão do Ubuntu, `zsh` o do
macOS. É também uma linguagem de programação.

**Terminal (ou emulador de terminal)** — a *janela* onde o shell roda. Windows Terminal, GNOME
Terminal, iTerm2. Não confunda: o terminal é o vidro, o shell é o que está atrás dele.

**systemd** — o gerenciador de serviços da maioria das distros modernas. É quem responde a
`systemctl start docker`.

---

## Arquivos e permissão

**FHS** — a árvore padrão do Linux: `/etc` configuração, `/usr/bin` programas, `/var/log` logs,
`/home` usuários. Sem letra de unidade: **tudo pendura de `/`**.

**`~` (til)** — atalho para a sua pasta pessoal, `/home/seu-usuario`.

**Caminho absoluto / relativo** — absoluto começa em `/` e sempre aponta para o mesmo lugar
(`/home/ana/projeto`). Relativo depende de onde você está (`../projeto`). Em script, prefira
absoluto: relativo muda de significado conforme quem chama.

**`rwx`** — **r**ead, **w**rite, e**x**ecute, para dono / grupo / outros. `chmod 644` = dono lê e
escreve, resto só lê. `chmod +x` liga o bit de execução, sem o qual um `.sh` não roda.

**Case-sensitive** — diferencia maiúscula de minúscula. **Linux sim**; macOS (APFS) e Windows
(NTFS), por padrão, **não**. É a causa do bug clássico "passa na minha máquina, quebra no CI".

**CRLF vs LF** — como se termina uma linha. Windows usa `CRLF`, Unix usa `LF`. Um `.sh` salvo com
`CRLF` falha com `bad interpreter: /bin/bash^M`.

**Tudo é arquivo** — a ideia central do Unix. Disco, processo, socket, dispositivo e até o estado
do kernel aparecem como arquivo (veja `/proc`). Um só par de verbos — ler e escrever — serve para
tudo, e é por isso que o pipe resolve tanta coisa.

---

## WSL

**WSL** — *Windows Subsystem for Linux*. A camada da Microsoft que roda Linux dentro do Windows.
**Não é uma distribuição**: dentro dele você escolhe Ubuntu, Debian, Alpine… Dizer "uso WSL" não
diz qual Linux você usa.

**WSL 1 vs WSL 2** — o 1 traduzia chamadas do Linux para o kernel do Windows, e Docker não rodava.
O **2 é uma máquina virtual leve com um kernel Linux de verdade**. Use sempre o 2.

**`/mnt/c`** — o disco C: do Windows visto de dentro do Linux. **Não guarde projeto aqui**: é
lento, `chmod` é ignorado sem avisar, e o bit de execução se perde.

**`\\wsl$\Ubuntu-24.04\...`** — o caminho inverso: os arquivos do Linux vistos do Explorer do
Windows.

---

## Pacotes

**Gerenciador de pacote** — instala, atualiza e remove software resolvendo dependências. `apt`
(Debian/Ubuntu/Mint), `dnf` (Fedora/RHEL), `pacman` (Arch), `apk` (Alpine), `zypper` (openSUSE),
`brew` (macOS, de terceiros), `winget` (Windows).

**Repositório (de pacotes)** — o servidor assinado de onde os pacotes vêm. `apt update` atualiza
a *lista*; `apt upgrade` atualiza os *pacotes*.

**LTS** — *Long Term Support*. Ubuntu LTS tem 5 anos de suporte, sai a cada 2 anos, e é o que
servidor usa. Para o curso: **Ubuntu 24.04 LTS**.

**Rolling release** — atualiza continuamente, sem versões (Arch, openSUSE Tumbleweed). Troca
previsibilidade por novidade. **Não é melhor nem pior — é outra escolha.**

**`glibc` vs `musl`** — duas implementações da biblioteca C. Quase todo Linux usa `glibc`; o
**Alpine** usa `musl`, e é por isso que binário pré-compilado às vezes não roda lá.

**`nvm`** — gerencia versões do Node por projeto. Use-o em vez de `apt install nodejs`, que dá
versão velha, global e presa à distribuição.

---

## Git

**Repositório** — a pasta do projeto mais o `.git`, que guarda o histórico inteiro.

**Commit** — um instantâneo com autor, data e mensagem. **O histórico é imutável por desenho**: um
commit novo não desfaz um antigo, ele acrescenta. É por isso que `git rm` não apaga um segredo do
passado.

**Branch** — uma linha de trabalho paralela. `main` é a principal.

**`origin`** — o apelido padrão do repositório remoto.

**Clone / push / pull** — baixar o repositório inteiro / enviar seus commits / trazer os dos
outros.

**PR (Pull Request)** — o pedido de "revisem e integrem a minha branch". É onde a revisão acontece.

**`.gitignore`** — a lista de caminhos que o Git deve ignorar. **`.env` entra aqui desde o primeiro
commit.**

**Staging (índice)** — a área intermediária entre o seu arquivo e o commit. `git add` põe ali;
`git commit` grava.

---

## Docker

**Imagem** — o modelo, imutável, com o programa e seus arquivos. `postgres:16`.

**Container** — uma instância rodando daquela imagem. No Linux, é um processo do seu próprio
kernel isolado por *namespaces* e *cgroups* — **não é máquina virtual**. No Windows e no macOS há
uma VM no meio, porque o kernel do host não é Linux.

**Volume** — onde os dados sobrevivem ao container. `docker rm` não apaga volume;
`docker compose down -v` apaga, e é definitivo.

**Bind mount** — uma pasta sua montada dentro do container. É a parte lenta no WSL e no macOS.

**`-p 5433:5432`** — publicação de porta, na ordem **host:container**. À esquerda a porta que você
usa; à direita a de dentro.

**`docker compose`** — sobe vários containers juntos, descritos num `docker-compose.yml`.

**`localhost` dentro do container** — **não é a sua máquina**, é o próprio container. Entre
serviços do mesmo compose, o endereço é o **nome do serviço** (`db:5432`).

---

## Do jeito que este curso fala

**Artefato** — a coisa concreta que você entrega ao fim de um módulo. No Módulo 0: a máquina
validada pelo script mais o repositório limpo.

**Critério de aceite** — a condição objetiva de "pronto", verificável por comando. Não é opinião
do instrutor.

**Semente** — o repositório com **defeito plantado** que você clona para trabalhar. O defeito é
proposital: é o exercício.

**Instrumento** — a ferramenta que mede (um script, um teste, um healthcheck). Regra da casa:
**instrumento também erra**, e a forma de confiar nele é testá-lo contra um caso que deveria
falhar.

**Controle (de duas pontas)** — provar que a medida discrimina: verde no caso correto **e**
vermelho num caso forjado. Sem a segunda ponta, um verde não significa nada.
