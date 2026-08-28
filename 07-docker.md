# 07 — Docker

**Tempo:** 25 min.
**Ao final:** um Postgres rodando na sua máquina, você conversando com ele, e entendendo por que
`localhost` dentro de um container **não é** a sua máquina.

---

## O que Docker resolve, sem marketing

Um container empacota o programa **e** o sistema de arquivos de que ele precisa. Você roda um
Postgres 16 sem instalar Postgres, e apaga sem deixar rastro. Nas imersões, é como banco, fila e
serviço de apoio sobem — ninguém instala nada disso na máquina.

**No Linux, container não é máquina virtual.** É um processo do seu próprio kernel, isolado por
*namespaces* (o que ele enxerga) e *cgroups* (quanto ele pode consumir). Por isso sobe em
milissegundos.

No **Windows e no macOS** existe uma VM no meio, porque o kernel do host não é Linux. Funciona
igual, custa mais memória, e compartilhar pasta com o container é mais lento.

---

## Os comandos que resolvem o dia

```bash
docker ps                       # o que está rodando AGORA
docker ps -a                    # inclusive o que parou
docker images                   # imagens baixadas
docker logs <nome>              # o que o container imprimiu
docker logs -f <nome>           # acompanhando ao vivo
docker exec -it <nome> bash     # entra num shell DENTRO do container
docker stop <nome>              # para
docker rm <nome>                # remove (precisa estar parado)
docker rmi <imagem>             # remove a imagem
```

Espaço em disco some rápido. Quando precisar:

```bash
docker system df                # quanto está ocupado, e com o quê
docker system prune             # remove o que não está em uso
docker system prune -a --volumes # remove MUITO mais, inclusive dados. Leia antes
```

---

## Prática: subir um Postgres

```bash
docker run -d \
  --name lab-pg \
  -e POSTGRES_PASSWORD=senha-de-lab \
  -e POSTGRES_DB=lab \
  -p 5433:5432 \
  postgres:16
```

Peça por peça:

| Trecho | O que faz |
|---|---|
| `-d` | roda ao fundo (*detached*) |
| `--name lab-pg` | dá um nome, para você não precisar do id |
| `-e ...` | variável de ambiente dentro do container |
| `-p 5433:5432` | **porta do host : porta do container** — a ordem importa |
| `postgres:16` | a imagem, com versão **fixada**. Nunca use `latest` |

Confira, e repare que são duas perguntas diferentes:

```bash
docker ps                                  # o container está de pé?
docker exec -it lab-pg psql -U postgres -d lab -c '\l'   # ele responde?
```

Container de pé não prova banco respondendo. Os dois checks existem porque falham por motivos
diferentes.

Brinque um pouco:

```bash
docker exec -it lab-pg psql -U postgres -d lab
```

```sql
CREATE TABLE aluno (id serial primary key, nome text);
INSERT INTO aluno (nome) VALUES ('eu');
SELECT * FROM aluno;
\q
```

Limpe:

```bash
docker stop lab-pg && docker rm lab-pg
```

---

## A escolha de porta que evita uma tarde perdida

Repare que subimos em **5433**, não 5432. De propósito.

`5432` é a porta padrão do Postgres. Se você já tiver um Postgres instalado na máquina — ou outro
projeto tiver subido um container — ele está lá. E aí acontece isto:

- `pg_isready` responde "accepting connections" ✅
- você conecta, e **está no banco errado**
- as tabelas não existem, e o erro fala de tabela ausente, não de servidor trocado

**Um servidor responder não prova que é o seu.** Publique cada projeto numa porta própria e anote
qual é. Quando algo não bater, o primeiro comando é:

```bash
docker ps --format '{{.Names}}\t{{.Ports}}'
```

Ele mostra `0.0.0.0:5433->5432/tcp`: **à esquerda a porta do host** (a que você usa), à direita a
de dentro do container.

---

## `localhost` tem três significados

Este é o conceito que mais confunde, e vale a leitura lenta:

| Onde você está | O que `localhost` significa |
|---|---|
| No seu terminal do Linux | a sua máquina |
| Dentro de um container | **o próprio container**, não a sua máquina |
| No Windows, falando com um serviço do WSL | normalmente funciona (o WSL encaminha) |

Consequência que pega todo mundo: uma aplicação **dentro** de um container que tenta falar com o
banco em `localhost:5432` está procurando o banco **dentro dela mesma**, e não acha.

Quando os dois estão no mesmo `docker compose`, o endereço do banco é o **nome do serviço**:

```yaml
# docker-compose.yml
services:
  db:
    image: postgres:16
    environment:
      POSTGRES_PASSWORD: senha-de-lab
    ports:
      - "5433:5432"          # para VOCÊ acessar de fora

  api:
    build: .
    environment:
      # de dentro da rede do compose: nome do serviço + porta INTERNA
      DATABASE_URL: postgres://postgres:senha-de-lab@db:5432/lab
    depends_on:
      - db
```

Repare na assimetria, que é a fonte da confusão: **você**, de fora, usa `localhost:5433`; a
**api**, de dentro, usa `db:5432`. Duas respostas certas para o mesmo banco, dependendo de quem
pergunta.

```bash
docker compose up -d      # sobe tudo
docker compose ps         # o que está de pé
docker compose logs -f    # acompanha
docker compose down       # derruba (dados de volume ficam)
docker compose down -v    # derruba E APAGA os volumes. Definitivo
```

---

## Três hábitos que evitam problema

**1. Fixe a versão da imagem.** `postgres:16`, não `postgres:latest`. `latest` muda debaixo de
você, e o dia em que quebrar não vai ter nada no seu diff explicando por quê.

**2. Segredo não vai no `docker-compose.yml` versionado.** Use `env_file:` apontando para um
`.env` que está no `.gitignore`. A mesma regra do [`06-git-e-github.md`](06-git-e-github.md).

**3. Volume é onde os dados moram.** `docker rm` apaga o container, não o volume. `docker compose
down -v` apaga o volume — e é definitivo. Antes de rodar com `-v`, pergunte-se se tem alguma coisa
ali que você quer.

---

## Pronto

- [ ] `docker run --rm hello-world` funciona sem `sudo`
- [ ] Você subiu um Postgres, criou uma tabela e derrubou
- [ ] Você sabe dizer por que `localhost` dentro do container não é a sua máquina
- [ ] Você sabe ler `0.0.0.0:5433->5432/tcp`

**Ambiente completo.** Rode o verificador oficial que vem com a semente:

```bash
PULAR_REPO=1 bash verificar-ambiente.sh
```

Verde em tudo? Você está pronto para a janela 1 — que é exatamente o que este módulo prometeu.
