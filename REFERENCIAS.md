# Referências e materiais de estudo

Curadoria, não catálogo. Cada item aqui responde a uma pergunta específica, e a pergunta está
escrita ao lado — assim você não abre dez abas para descobrir qual serve.

**Regra que vale para todos:** prefira sempre a **documentação oficial** a um tutorial de blog.
Tutorial de instalação apodrece rápido — a versão muda, um passo deixa de existir, e você fica
depurando um problema que não é seu. Quando um link daqui divergir da doc oficial, a oficial manda.

---

## Documentação oficial (comece por aqui)

| O quê | Link | Quando abrir |
|---|---|---|
| WSL | <https://learn.microsoft.com/windows/wsl/> | instalar, configurar `wsl.conf`, entender a arquitetura |
| Ubuntu Server Guide | <https://ubuntu.com/server/docs> | administrar, serviços, rede |
| Docker | <https://docs.docker.com/get-started/> | do zero ao compose |
| Git — livro Pro Git | <https://git-scm.com/book/pt-br/v2> | **em português, e é o melhor material que existe** |
| GitHub Docs | <https://docs.github.com> | SSH, PR, Actions |
| Node / nvm | <https://github.com/nvm-sh/nvm> | instalar e trocar versão |
| GitHub CLI | <https://cli.github.com/manual/> | `gh` inteiro |
| ArchWiki | <https://wiki.archlinux.org> | **a melhor doc de Linux que existe, e serve para qualquer distro** |

Sobre a ArchWiki: você não precisa usar Arch para usá-la. Quando quiser entender *de verdade* como
uma peça do Linux funciona — SSH, systemd, permissão, rede — ela costuma ser a melhor página da
internet sobre o assunto.

---

## Shell e linha de comando

**Para praticar de graça, no navegador**

- **OverTheWire: Bandit** — <https://overthewire.org/wargames/bandit/>
  Um jogo em 30+ níveis onde cada fase se resolve com um comando de shell. **É a melhor forma de
  aprender terminal que existe**, porque você não decora: você precisa. Faça os níveis 0-15;
  cobrem tudo do [`04-primeiros-passos-shell.md`](04-primeiros-passos-shell.md) e mais um pouco.

- **Linux Journey** — <https://linuxjourney.com>
  Trilha curta e visual, do zero até processos e permissão. Bom para quem prefere ler antes de
  digitar.

- **explainshell** — <https://explainshell.com>
  Cole um comando e ele explica **cada flag separadamente**. Achou uma linha assustadora num
  tutorial? Cole aqui antes de rodar. Especialmente antes de rodar com `sudo`.

**Referência de consulta**

- **tldr pages** — <https://tldr.sh> (ou `sudo apt install -y tldr`, e `tldr tar`)
  Exemplos práticos em vez da densidade do `man`.
- **ShellCheck** — <https://www.shellcheck.net>
  Cole um script `.sh` e ele aponta os erros que só aparecem em produção. Use em todo script que
  você escrever no curso.
- **The Missing Semester (MIT)** — <https://missing.csail.mit.edu/>
  O curso que ensina o que as faculdades não ensinam: shell, git, editores, depuração. As aulas 1,
  2 e 6 são as mais úteis agora. Tem legenda.

---

## Git

- **Pro Git, em português** — <https://git-scm.com/book/pt-br/v2>
  Capítulos 1 a 3 cobrem tudo do módulo. É livro de verdade, gratuito, e resiste ao tempo.
- **Learn Git Branching** — <https://learngitbranching.js.org/?locale=pt_BR>
  Visual e interativo. Se `merge` e `rebase` te confundem, uma hora aqui resolve.
- **Oh Shit, Git!?!** — <https://ohshitgit.com/pt_br>
  "Fiz besteira, como desfaço" organizado por situação. Salva a tarde.
- **git-filter-repo** — <https://github.com/newren/git-filter-repo>
  A ferramenta para remover um segredo do histórico. Leia antes de precisar, não durante.

---

## Docker

- **Docker curriculum** — <https://docker-curriculum.com>
  Tutorial honesto do zero, com um app de verdade no fim.
- **Play with Docker** — <https://labs.play-with-docker.com>
  Um Docker no navegador, sem instalar nada. Útil para experimentar sem sujar a máquina.
- **Docker — best practices para Dockerfile** — <https://docs.docker.com/build/building/best-practices/>
  Volte aqui quando escrever o seu primeiro Dockerfile, não agora.

---

## Segurança básica (leia antes do dia 3)

- **GitHub — remover dados sensíveis** — <https://docs.github.com/pt/authentication/keeping-your-account-and-data-secure/removing-sensitive-data-from-a-repository>
  O procedimento oficial, e o aviso que importa: **rotacione o segredo primeiro**. Limpar o
  histórico não desvaza o que já vazou.
- **gitleaks** — <https://github.com/gitleaks/gitleaks>
  Varre um repositório atrás de segredo. Rode no seu antes de publicar qualquer coisa.
- **OWASP Top 10** — <https://owasp.org/www-project-top-ten/>
  Fora do escopo do Módulo 0, mas é a base da imersão 12. Vale conhecer o índice.

---

## Vídeo, em português

Vídeo envelhece mais rápido que texto — **confira a data antes de seguir um passo a passo**, e
compare com a doc oficial se for mais velho que um ano.

- **Canal do Diolinux** — Linux para quem está começando, com bom senso e sem fanatismo.
- **Fabio Akita** — as playlists sobre carreira, arquitetura e o funcionamento das coisas por
  baixo. Denso, longo, e vale.
- **Rocketseat / Full Cycle** — trechos avulsos sobre Docker e Git são bons; ignore o funil de
  curso.

---

## Quando você quiser ir mais fundo

Nada aqui é necessário para o Módulo 0. É a lista de "depois que a máquina estiver de pé":

- **How Linux Works**, Brian Ward — o que acontece do boot ao seu shell. O livro que transforma
  "eu uso Linux" em "eu entendo Linux".
- **The Linux Command Line**, William Shotts — <https://linuxcommand.org/tlcl.php> (PDF gratuito)
  600 páginas de shell, do básico a scripting. Referência para a vida.
- **Linux Kernel Map** — <https://makelinux.github.io/kernel/map/>
  Um mapa visual do kernel. Não é para estudar; é para ver o tamanho da coisa.

---

## Como pedir ajuda (e receber)

Vale para o chat da turma, para o Stack Overflow e para qualquer lugar:

1. **O comando, copiado.** Não digitado de novo — o erro pode estar justamente na digitação.
2. **A mensagem inteira, copiada.** Não a sua paráfrase. A causa costuma estar no fim, não na
   primeira linha.
3. **O que você já tentou.** Evita que te mandem repetir.
4. **O contexto:** sistema, distro, versão. `uname -a` e `cat /etc/os-release` respondem.

E o hábito que mais vale, este aqui: **antes de perguntar, cole a mensagem de erro exata num
buscador, entre aspas.** Na esmagadora maioria das vezes, alguém já passou por ela e a resposta
está no primeiro resultado. Perguntar é ótimo — perguntar sem ter feito isso desperdiça o tempo de
duas pessoas.
