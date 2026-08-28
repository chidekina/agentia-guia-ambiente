# 02 — Linux nativo

**Tempo:** 15-30 min se já tem Linux instalado. Instalar do zero é outra conversa — veja o fim
desta página.
**Ao final:** a máquina pronta, e você sabendo traduzir os comandos do curso para a sua distro.

---

## Já usa Linux? Você fica na sua distro

O curso padroniza em **Ubuntu 24.04 LTS**, e a razão é operacional, não técnica: é a distribuição
que toda a documentação da internet assume. Mas se você já roda Mint, Fedora, Arch, Debian ou
openSUSE **e está confortável**, fique. Trocar de distribuição no meio do módulo é a única escolha
errada aqui.

O que você precisa é saber **traduzir**. Descubra primeiro onde está:

```bash
cat /etc/os-release      # nome, versão, e o campo ID_LIKE
uname -r                 # versão do kernel
```

O campo **`ID_LIKE`** é o que responde a pergunta que importa: *"posso seguir um tutorial de
Ubuntu aqui?"*. Se disser `debian`, sim — o comando de pacote é o mesmo. Vale mais que o nome
bonito da distro.

---

## A tabela de tradução

Todo comando do curso aparece na forma `apt`. Esta é a mesma coisa nas outras famílias:

| Tarefa | Debian / Ubuntu / Mint | Fedora / RHEL | Arch / Manjaro | openSUSE | Alpine |
|---|---|---|---|---|---|
| Atualizar índice | `sudo apt update` | `sudo dnf check-update` | `sudo pacman -Sy` | `sudo zypper refresh` | `sudo apk update` |
| Instalar | `sudo apt install git` | `sudo dnf install git` | `sudo pacman -S git` | `sudo zypper install git` | `sudo apk add git` |
| Remover | `sudo apt remove git` | `sudo dnf remove git` | `sudo pacman -R git` | `sudo zypper remove git` | `sudo apk del git` |
| Procurar | `apt search termo` | `dnf search termo` | `pacman -Ss termo` | `zypper search termo` | `apk search termo` |
| Atualizar tudo | `sudo apt upgrade` | `sudo dnf upgrade` | `sudo pacman -Syu` | `sudo zypper update` | `sudo apk upgrade` |
| Que pacote traz este arquivo | `dpkg -S /bin/ls` | `rpm -qf /bin/ls` | `pacman -Qo /bin/ls` | `rpm -qf /bin/ls` | `apk info --who-owns /bin/ls` |

Vale copiar essa tabela para um arquivo seu. A pergunta *"qual é o `apt` daqui?"* volta toda vez
que você entra num servidor que não é o seu.

---

## O essencial, em uma linha

**Debian / Ubuntu / Mint / Pop!_OS:**

```bash
sudo apt update && sudo apt install -y build-essential curl git jq ripgrep
```

**Fedora / RHEL / Rocky / Alma:**

```bash
sudo dnf install -y @development-tools curl git jq ripgrep
```

**Arch / Manjaro:**

```bash
sudo pacman -Syu --needed base-devel curl git jq ripgrep
```

Confira:

```bash
git --version
gcc --version      # veio do build-essential / base-devel
```

---

## Uma vantagem que você tem sobre a turma do WSL

**Docker roda nativo aqui.** Sem VM no meio, sem fronteira de sistema de arquivos, sem `/mnt/c`.
Container no Linux é um processo do seu próprio kernel isolado por *namespaces* e *cgroups* — não
há máquina virtual nenhuma. É por isso que container nasceu no Linux, e é por isso que no Windows
e no macOS ele precisa de uma VM para existir.

Consequência prática: quando a turma do WSL estiver lidando com lentidão de bind mount no dia 2,
você não vai ter esse problema. Aproveite para ajudar quem tiver.

---

## Dual boot ou instalação do zero

Se você **ainda não tem** Linux e quer instalar ao lado do Windows, três avisos honestos:

**1. Faça backup antes de particionar.** Não "vou fazer depois". Antes. Redimensionar partição
é a operação com maior chance de perda de dados de todo este guia, e ela não pergunta "tem
certeza?" de forma útil.

**2. Não faça isso ao vivo durante a aula.** Particionamento não é conduzido em turma — cada disco
tem uma história, e a que dá errado sempre é a de alguém. Traga para atendimento individual no lab.

**3. Se a sua meta é só ter Linux para programar, o WSL2 resolve com muito menos risco.** Dual boot
faz sentido quando você quer o Linux como sistema principal, não como ferramenta de trabalho.

O caminho, em resumo, para quem vai mesmo:

```
1. Backup completo dos seus arquivos, num disco que não é o que vai ser particionado
2. Baixar Ubuntu 24.04 LTS   → https://ubuntu.com/download/desktop
3. Gravar um pendrive        → Rufus (Windows) ou Balena Etcher
4. Desligar "Fast Startup" no Windows e "Secure Boot" na UEFI se der conflito
5. Bootar pelo pendrive, escolher "Instalar ao lado do Windows"
6. Deixar 50 GB no mínimo para o Linux
```

Detalhe cada passo com a documentação oficial listada em [`REFERENCIAS.md`](REFERENCIAS.md) — um
guia de particionamento em segunda mão é como você perde dados.

---

## Pronto para o próximo

- [ ] `cat /etc/os-release` responde, e você sabe qual é a sua família
- [ ] Você sabe traduzir `apt install` para a sua distro
- [ ] `git --version` responde
- [ ] `gcc --version` responde

→ [`04-primeiros-passos-shell.md`](04-primeiros-passos-shell.md)
