# 01 — Windows: instalar o WSL2

**Tempo:** 40-60 min, boa parte esperando download.
**Ao final:** um Ubuntu 24.04 rodando dentro do Windows, com `uname -a` respondendo `WSL2`.

---

## O que é WSL2, em três frases

WSL2 é uma **máquina virtual leve** que roda um kernel Linux **de verdade**, compilado pela
Microsoft, e que inicia em segundos. Não é um emulador nem uma tradução: é Linux, com o mesmo
`apt`, o mesmo Docker e os mesmos arquivos de configuração de qualquer Ubuntu.

O que ele **não** apaga é a fronteira: são dois sistemas de arquivos separados, o do Windows e o
do Linux, e atravessar essa fronteira custa caro. É de onde vem a única regra que você precisa
decorar hoje — está no fim desta página.

> Existiu um WSL **1**, que traduzia chamadas do Linux para o kernel do Windows. Funcionava até
> não funcionar: Docker não rodava. Se algum tutorial antigo falar em WSL 1, ele está
> desatualizado.

---

## Antes de começar: requisitos

| Item | Como conferir |
|---|---|
| Windows 10 versão 2004+ ou Windows 11 | `Win+R` → `winver` |
| Virtualização ligada na BIOS/UEFI | Gerenciador de Tarefas → Desempenho → CPU → "Virtualização: Habilitado" |
| ~5 GB livres em disco | — |

**Virtualização desabilitada é o motivo nº 1 de falha aqui.** Se o Gerenciador de Tarefas disser
"Desabilitado", você precisa ligar na BIOS antes de continuar — reiniciar, entrar na BIOS
(geralmente `Del`, `F2` ou `F10` no boot) e procurar por `Intel VT-x`, `AMD-V` ou `SVM Mode`.
Não dá para contornar isso pelo Windows.

---

## Passo 1 — Instalar

Abra o **PowerShell como Administrador** (botão direito no menu Iniciar → "Terminal
(Administrador)") e rode:

```powershell
wsl --install -d Ubuntu-24.04
```

Vai baixar, instalar e pedir para **reiniciar**. Reinicie de verdade — "suspender" não conta.

Depois de reiniciar, uma janela do Ubuntu abre sozinha e pede:

```
Enter new UNIX username:
New password:
```

Duas coisas sobre essa senha:

- **Não é a senha do Windows.** É uma conta nova, só do Linux.
- **A senha não aparece enquanto você digita.** Nem asterisco, nem bolinha, nada. Isso é normal
  e é assim em todo Unix — digite e dê Enter. Não é travamento.

Guarde essa senha: é ela que o `sudo` vai pedir daqui em diante.

---

## Passo 2 — Confirmar que é WSL **2**

Ainda no PowerShell:

```powershell
wsl --status
wsl --list --verbose
```

A coluna `VERSION` tem de dizer **2**. Se disser 1:

```powershell
wsl --set-default-version 2
wsl --set-version Ubuntu-24.04 2
```

A conversão demora alguns minutos e não pode ser interrompida.

> **Curiosidade útil:** `wsl --list --online` mostra que Ubuntu não é a única opção — há Debian,
> Kali, openSUSE, Oracle Linux. Para este curso, **fique no Ubuntu 24.04**: é a distribuição que
> toda a documentação da internet assume, e isso vale mais que preferência pessoal.

---

## Passo 3 — Verificar que funciona (não que instalou)

Instalar e funcionar são coisas diferentes. Abra o **Ubuntu** (menu Iniciar → Ubuntu) e rode:

```bash
uname -a
```

A resposta **tem de conter** `Linux` e `WSL2`. Algo assim:

```
Linux DESKTOP-XYZ 5.15.167.4-microsoft-standard-WSL2 #1 SMP ... x86_64 GNU/Linux
                  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ é isto que você procura
```

Em seguida:

```bash
cat /etc/os-release      # tem de dizer Ubuntu 24.04
whoami                   # o usuário que você criou
sudo apt update          # vai pedir a senha do Linux
sudo apt install -y build-essential curl git
```

Se `sudo apt update` terminou sem erro vermelho, **o essencial está de pé.**

---

## Passo 4 — O editor

Instale o **VS Code no Windows** (não dentro do Linux) e a extensão **WSL**:

1. Baixe em <https://code.visualstudio.com> e instale normalmente.
2. Dentro do VS Code: `Ctrl+Shift+X` → procure por `WSL` → instale a extensão da Microsoft.
3. No terminal do Ubuntu, dentro de uma pasta qualquer:

```bash
code .
```

Na primeira vez ele instala um servidorzinho dentro do Linux e abre a janela conectada. O canto
inferior esquerdo passa a mostrar **`WSL: Ubuntu-24.04`** — é assim que você sabe que está
editando os arquivos do Linux, e não cópias do Windows.

**Esse é o único ponto em que o Windows entra no seu fluxo:** o editor roda lá, os arquivos ficam
aqui.

---

## A regra que vale para o curso inteiro

> ### O projeto mora em `~`, dentro do Linux. Nunca em `/mnt/c`.

Você vai ver `/mnt/c` no seu Ubuntu — é o disco C: do Windows, montado ali. É tentador guardar o
projeto em `/mnt/c/Users/SeuNome/projetos`, perto do resto das suas coisas. **Não faça isso**, por
três motivos que não são opinião:

**1. É lento, e a diferença é de ordem de grandeza.**
Todo acesso a `/mnt/c` atravessa a fronteira entre os dois sistemas. Você mede isso sozinho —
clonar o mesmo repositório nos dois lugares e comparar:

```bash
cd ~           && time git clone --depth 1 https://github.com/git/git.git t1
cd /mnt/c/Users/$USER 2>/dev/null && time git clone --depth 1 https://github.com/git/git.git t2
# apague depois:  rm -rf ~/t1 /mnt/c/Users/$USER/t2
```

**2. Permissão não atravessa.** Arquivo em `/mnt/c` aparece como `777` para tudo, e `chmod` ali é
ignorado **sem avisar**. O sintoma clássico: uma chave SSH guardada em `/mnt/c` é recusada pelo
`ssh` por estar "com permissão frouxa demais", e nenhum `chmod 600` resolve.

**3. O bit de execução se perde.** Um `.sh` que você salvou no Windows não roda no Linux, e o erro
(`Permission denied`) não diz que a causa é essa.

**Onde as coisas ficam, então:**

```bash
mkdir -p ~/projetos      # aqui dentro. Sempre.
cd ~/projetos
```

Precisa abrir a pasta do Linux no Explorer do Windows? Do terminal:

```bash
explorer.exe .
```

Ou digite `\\wsl$\Ubuntu-24.04\home\seu-usuario` na barra do Explorer.

---

## Duas armadilhas que aparecem no dia 2 (leia agora, sofra menos)

**Fim de linha.** O Windows termina linha com `CRLF`; o Linux, com `LF`. Um `.sh` salvo por um
editor do Windows falha com uma mensagem que não parece ser sobre isso:

```
./script.sh: line 1: #!/usr/bin/env: bad interpreter: /bin/bash^M: No such file or directory
                                                              ^^ este é o CR sobrando
```

Previna de uma vez:

```bash
git config --global core.autocrlf input
```

E para diagnosticar um arquivo suspeito: `file script.sh` diz `with CRLF line terminators`.

**`localhost` tem dois lados.** Um serviço que você sobe dentro do WSL é alcançável pelo navegador
do Windows em `localhost:PORTA`. O contrário nem sempre funciona. E dentro de um container Docker,
`localhost` não é a sua máquina — é o **próprio container**. Isso volta com calma no
[`07-docker.md`](07-docker.md).

---

## Pronto para o próximo

- [ ] `uname -a` responde com `Linux` e `WSL2`
- [ ] `cat /etc/os-release` diz Ubuntu 24.04
- [ ] `sudo apt update` roda sem erro
- [ ] VS Code abre com `code .` e mostra `WSL: Ubuntu-24.04` no canto
- [ ] Você sabe dizer por que o projeto não vai em `/mnt/c`

Alguma caixa vazia? [`PROBLEMAS.md`](PROBLEMAS.md).
Todas marcadas? → [`04-primeiros-passos-shell.md`](04-primeiros-passos-shell.md)
