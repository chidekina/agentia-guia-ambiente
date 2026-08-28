# Solução de problemas

Sintoma → causa → ação. Procure pela **mensagem exata** (`Ctrl+F`), não pela sua descrição do que
aconteceu.

Se o seu erro não está aqui, leve para o chat da turma com as três coisas do
[`README`](README.md#como-este-guia-trata-erro): o comando, a mensagem inteira, e o que você já
tentou. E, quando resolver, **abra uma issue** para o próximo achar aqui.

---

## Instalação do WSL

### `WslRegisterDistribution failed: 0x80370102`

**Causa:** virtualização desligada na BIOS/UEFI, ou o recurso de VM do Windows não está habilitado.

**Ação:**
1. Gerenciador de Tarefas → Desempenho → CPU. Se "Virtualização: Desabilitado", reinicie e entre
   na BIOS (`Del`, `F2` ou `F10` no boot). Procure `Intel VT-x`, `AMD-V` ou `SVM Mode` e ligue.
2. No Windows, PowerShell como Administrador:
   ```powershell
   dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
   dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
   ```
3. Reinicie de verdade.

### `wsl --list --verbose` diz VERSION 1

**Causa:** o padrão da máquina ainda é a versão antiga.

```powershell
wsl --set-default-version 2
wsl --set-version Ubuntu-24.04 2
```

A conversão leva minutos e não pode ser interrompida.

### A senha não aparece quando eu digito

**Não é travamento.** Nenhum Unix mostra a senha, nem em asterisco. Digite e dê Enter.

### `wsl --install` não é reconhecido

Windows antigo demais. Confira com `winver`: precisa ser Windows 10 versão 2004 (build 19041) ou
superior. Atualize o Windows antes.

---

## Rede e `apt`

### Sem internet dentro do WSL

**Causa:** quase sempre DNS, e não rede. Separe as duas coisas — esta é a parte que importa:

```bash
ping -c 2 1.1.1.1        # testa REDE (número, sem DNS)
ping -c 2 google.com     # testa DNS  (nome)
```

- Falhou o primeiro → é rede. VPN corporativa, firewall.
- Passou o primeiro e falhou o segundo → **é DNS**. Só isso:
  ```bash
  cat /etc/resolv.conf
  echo "nameserver 1.1.1.1" | sudo tee /etc/resolv.conf
  ```
  Para o WSL não sobrescrever esse arquivo no próximo boot, crie `/etc/wsl.conf` com:
  ```ini
  [network]
  generateResolvConf = false
  ```
  e depois `wsl --shutdown` no PowerShell.

> Testar só `ping google.com` responde "não tem internet" para **duas** falhas diferentes, com
> consertos diferentes. Duas medições separam.

### `apt update` lento, ou erro 403

Proxy corporativo. Configure em `/etc/apt/apt.conf.d/95proxy`:

```
Acquire::http::Proxy "http://usuario:senha@proxy.empresa:8080";
Acquire::https::Proxy "http://usuario:senha@proxy.empresa:8080";
```

Ou use uma rede pessoal para instalar.

### `Could not get lock /var/lib/dpkg/lock-frontend`

Outro `apt` está rodando — normalmente a atualização automática do sistema. Espere 2 minutos e
tente de novo. Se persistir:

```bash
ps aux | grep -E 'apt|dpkg'      # veja QUEM está segurando antes de matar
```

Só mate o processo se você reconhecer o que é. Matar `dpkg` no meio de uma instalação deixa o
sistema de pacotes quebrado.

---

## Permissão

### `Permission denied` ao rodar um `.sh`

**Causa:** falta o bit de execução.

```bash
ls -la script.sh     # tem 'x' nas permissões?
chmod +x script.sh
```

Se o arquivo está em `/mnt/c`, `chmod` **não funciona** — mova para dentro do Linux primeiro.

### `bad interpreter: /bin/bash^M`

**Causa:** o arquivo tem fim de linha do Windows (`CRLF`). O `^M` é o caractere sobrando.

```bash
file script.sh                     # confirma: "with CRLF line terminators"
sed -i 's/\r$//' script.sh         # conserta este arquivo
git config --global core.autocrlf input   # evita o próximo
```

### `WARNING: UNPROTECTED PRIVATE KEY FILE` no SSH

**Causa:** a chave está com permissão frouxa — quase sempre porque está em `/mnt/c`.

```bash
chmod 700 ~/.ssh && chmod 600 ~/.ssh/id_ed25519
```

Se estiver em `/mnt/c`, **mover é a única solução**: permissão não atravessa a fronteira do WSL, e
o `chmod` ali é ignorado sem avisar.

---

## Docker

### `permission denied while trying to connect to the Docker daemon socket`

**Causa:** seu usuário não está no grupo `docker`, ou **a sessão ainda não releu o grupo**.

```bash
sudo usermod -aG docker $USER
```

E então **feche o terminal e abra de novo**. No WSL: `wsl --shutdown` no PowerShell, reabrir o
Ubuntu. Grupo é lido no login — o comando não tem efeito na sessão aberta, e é aqui que quase
todo mundo trava.

### `Cannot connect to the Docker daemon`

O serviço não está de pé:

```bash
sudo service docker start        # WSL
sudo systemctl start docker      # Linux nativo
docker info                      # confirma
```

### `port is already allocated`

Outra coisa já está naquela porta.

```bash
docker ps --format '{{.Names}}\t{{.Ports}}'    # quem publica o quê
ss -lptn 'sport = :5432'                        # quem está na porta
```

Suba na sua porta em vez de matar o do vizinho: `-p 5433:5432`.

### O container sobe e morre logo em seguida

```bash
docker ps -a           # confirma que parou, e o código de saída
docker logs <nome>     # a razão está aqui
```

A mensagem está sempre no log. Container que sai com código 0 terminou o trabalho; com código
diferente de 0, quebrou — e o log diz onde.

---

## Node

### `node: command not found` depois de instalar o `nvm`

O instalador acrescentou linhas ao seu `~/.bashrc`, e a sessão atual não as leu.

```bash
source ~/.bashrc     # ou feche e abra o terminal
nvm --version
```

### Versão do Node errada num projeto

```bash
cat .nvmrc      # o projeto declara a versão?
nvm use         # sem argumento, ele lê o .nvmrc
```

---

## Git

### `Support for password authentication was removed`

Você está usando HTTPS. Migre para SSH (veja [`06-git-e-github.md`](06-git-e-github.md)):

```bash
git remote set-url origin git@github.com:usuario/repo.git
git remote -v      # confirme o efeito
```

### `Permission denied (publickey)`

```bash
ssh -T git@github.com     # o teste isolado
ssh-add -l                # a chave está no agente?
ssh-add ~/.ssh/id_ed25519
```

Se `ssh-add -l` disser "Could not open a connection", o agente não está rodando:
`eval "$(ssh-agent -s)"`.

### `git push` falha no primeiro push de uma branch nova

```bash
git push -u origin HEAD     # o -u só é necessário na primeira vez
```

### Commitei um segredo, e agora?

Na ordem, e a ordem importa:

1. **Rotacione o segredo.** Invalide a chave e gere outra. Esta é a parte que protege — assuma que
   o valor foi lido.
2. Só então reescreva o histórico (`git filter-repo` ou BFG).
3. Avise quem já clonou: o histórico antigo continua nos clones deles.

`git rm --cached` **não** resolve — ele tira do próximo commit e deixa todos os anteriores.
Detalhado em [`06-git-e-github.md`](06-git-e-github.md#a-armadilha-do-módulo-git-rm-não-apaga-o-passado).

---

## Coisas que parecem quebradas e não estão

| O que você vê | O que é |
|---|---|
| A senha não aparece ao digitar | comportamento normal de todo Unix |
| `ssh -T git@github.com` diz "does not provide shell access" | é o sucesso; leia a linha anterior |
| `man` abriu e não sai | aperte `q` |
| O terminal "travou" depois de um comando | provavelmente está esperando entrada. `Ctrl+C` cancela |
| `apt` avisa sobre pacotes que podem ser removidos | informativo; só age se você mandar |
| Ficou preso em `>` no terminal | aspas abertas. `Ctrl+C` cancela a linha |

---

## Quando nada disso servir

Três perguntas que resolvem mais que qualquer comando:

1. **Qual foi a última coisa que funcionou?** O problema está entre aquilo e agora.
2. **Eu li a mensagem inteira?** Não a primeira linha — a inteira. A causa costuma estar no fim.
3. **Estou olhando para o estado certo?** Diretório certo, container certo, porta certa, máquina
   certa. Boa parte dos "não funciona" é uma ferramenta respondendo com confiança sobre outra
   coisa. Um `pwd` e um `docker ps` antes de investigar economizam muita tarde.
