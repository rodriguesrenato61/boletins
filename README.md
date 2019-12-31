# Boletins MySQL

Banco de dados para armazenar os boletins dos alunos em MySQL.

## Tabelas

### alunos

Armazena os dados dos alunos.

![alunos](https://github.com/rodriguesrenato61/boletins/blob/master/img/alunos.png)

### disciplinas

Armazena os dados das disciplinas.

![disciplinas](https://github.com/rodriguesrenato61/boletins/blob/master/img/disciplinas.png)

### alunos_disciplinas

Armazena os dados dos boletins dos alunos.

![alunos_disciplinas](https://github.com/rodriguesrenato61/boletins/blob/master/img/alunos_disciplinas.png)

## Views

### vw_alunos

Exibe a matrícula, nome, quantidade de disciplinas que faz, quantidade de aprovações, quantidade de reprovações e quantidade de recuperações do aluno.

![vw_alunos](https://github.com/rodriguesrenato61/boletins/blob/master/img/vw_alunos.png)

### vw_disciplinas

Exibe o código, nome, quantidade de alunos, quantidade de aprovados, quantidade de reprovados e quantidade de alunos que estão de recuperação na disciplina.

![vw_disciplinas](https://github.com/rodriguesrenato61/boletins/blob/master/img/vw_disciplinas.png)

### vw_boletins

Exibe o id, matrícula do aluno, aluno, código da disciplina, disciplina, nota 1, nota 2, nota 3, nota 4, média das notas e situação do aluno. 

![vw_boletins](https://github.com/rodriguesrenato61/boletins/blob/master/img/vw_boletins.png)

## Functions

### cont_alunos

Conta a quantidade de alunos que faz determinada disciplina.

### cont_disciplinas

Conta a quantidade de disciplinas que determinado aluno faz.

### cont_situacao_aluno

Conta a quantidade de aprovações, reprovações ou recuperações que o aluno possui.

### cont_situacao_disciplina

Conta a quantidade de alunos que estão em determinada situação em certa disciplina.

### faz_disciplina

Verifica se determinado aluno faz certa disciplina.

### media

Calcula a média das 4 notas.

### situacao

Retorna a situação do aluno de acordo com sua média.

### valida_nota

Verifica se a nota é um número válido de 0 a 10.

## Procedures

### insert_aluno

Insere um novo aluno no banco verificando se o seu nome já está ou não em uso.

### insert_disciplina

Insere uma nova disciplina no banco verificando se o seu nome já está ou não em uso.

### insert_aluno_disciplina

Insere um novo boletim verificando se já existe algum boletim desse aluno com essa disciplina.

### update_aluno

Atualiza os dados do aluno garantindo que não tenha nenhum outro com os mesmos dados.

### update_disciplina

Atualiza os dados da disciplina garantindo que não tenha nenhuma outra com os mesmos dados.

### update_aluno_disciplina

Atualiza as notas de um boletim garantindo que elas estão todas válidas.

### delete_aluno

Deleta um aluno do banco.

### delete_disciplina

Deleta uma disciplina do banco.

### delete_aluno_disciplina

Deleta um boletim do banco.

## Triggers

### tgr_delete_aluno

Deleta todos os registros de boletins do aluno deletado.

### tgr_delete_disciplina

Deleta todos os registros de boletins da disciplina deletada.

