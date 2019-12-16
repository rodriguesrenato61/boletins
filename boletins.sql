/*Se for feito pelo phpmyadmin defina o padrão de caracteres como utf8_general_ci.
E ao criar o banco por ele ignore as duas primeiras linhas, a de criar o banco e de acessar*/

/*Criando banco*/
CREATE DATABASE boletins;

/*Acessando o banco*/
USE boletins;

/*Criando tabelas*/

/*Tabela alunos
Armazena os dados dos alunos*/
CREATE TABLE alunos(
matricula INTEGER AUTO_INCREMENT,
nome VARCHAR(60),
PRIMARY KEY(matricula)
);
/*
matricula: chave primária,
nome: nome do aluno
*/

/*Tabela disciplinas
Armazena os dados das discipiplinas
*/
CREATE TABLE disciplinas(
codigo INTEGER AUTO_INCREMENT,
nome VARCHAR(60),
PRIMARY KEY(codigo)
);
/*
codigo: chave primária,
nome: nome da disciplina
*/

/*Tabela alunos_disciplinas
Armazena o boletim dos alunos nas disciplinas que eles cursam*/
CREATE TABLE alunos_disciplinas(
id INTEGER AUTO_INCREMENT,
matr_aluno INTEGER,
cod_disciplina INTEGER,
n1 DOUBLE,
n2 DOUBLE,
n3 DOUBLE,
n4 DOUBLE,
PRIMARY KEY(id),
FOREIGN KEY(matr_aluno) REFERENCES alunos(matricula),
FOREIGN KEY(cod_disciplina)REFERENCES disciplinas(codigo)
);
/*
id: chave primária,
matr_aluno: chave estrangeira para tabela alunos,
cod_disciplina: chave estrangeira para tabela disciplinas,
n1: nota do bimestre 1,
n2: nota do bimestre 2,
n3: nota do bimestre 3, 
n4: nota do bimestre 4
*/

/*Criando functions*/

/*Function media
Calcula a média das 4 notas do aluno*/
DELIMITER $$
CREATE FUNCTION media(nota1 DOUBLE, nota2 DOUBLE, nota3 DOUBLE, nota4
DOUBLE)
RETURNS DOUBLE
	BEGIN
	
		SET @media = (nota1 + nota2 + nota3 + nota4) / 4;/*calculando a média*/
		
		RETURN @media;/*retornando a média*/
	END $$

/*Function situacao
Retorna a situação do aluno na disciplina de acordo com sua média*/
CREATE FUNCTION situacao(nota1 DOUBLE, nota2 DOUBLE, nota3 DOUBLE, nota4
DOUBLE)
RETURNS VARCHAR(12)
	BEGIN
		
		SET @media = media(nota1, nota2, nota3, nota4);/*calculando média*/
			
		IF(@media >= 7)THEN/*se média for maior igual a 7 ele está aprovado*/
				
			SET @situacao = "Aprovado";
			
		END IF;
		IF(@media >= 6 AND @media < 7)THEN/*se média for maior igual a 6 e menor que 7 ele está de recuperação*/

			SET @situacao = "Recuperação";

		END IF;
		IF(@media < 6)THEN/*se média menor que 6 ele está reprovado*/

			SET @situacao = "Reprovado";
			
		END IF;
	
	RETURN @situacao;/*retorna situação do aluno*/
	END $$

/*Function cont_alunos
Conta a quantidade de alunos que faz determinada disciplina*/
CREATE FUNCTION cont_alunos(codigo_disciplina INTEGER)
RETURNS INTEGER
	BEGIN
	
	SET @alunos = (SELECT COUNT(*) FROM alunos_disciplinas WHERE cod_disciplina = codigo_disciplina);/*contando a quantidade de alunos que fazem essa disciplina*/
	
	RETURN @alunos;/*retornando quantidade de alunos que fazem essa disciplina*/
	END $$

/*Function cont_disciplinas
Conta a quantidade de disciplinas que determinado aluno faz*/
CREATE FUNCTION cont_disciplinas(matricula_aluno INTEGER)
RETURNS INTEGER
	BEGIN

		SET @disciplinas = (SELECT COUNT(*) FROM alunos_disciplinas WHERE matr_aluno = matricula_aluno);/*contando a quantidade de disciplinas que esse aluno faz*/

	RETURN @disciplinas;/*retornando quantidade de disciplinas que esse aluno cursa*/
	END $$

/*Function cont_situacao
Conta a quantidade de alunos que fazem determinada disciplina que estão nessa situação (aprovado, reprovado ou recuperação)*/
CREATE FUNCTION cont_situacao_disciplina(codigo_disciplina INTEGER, situacao VARCHAR(12))
RETURNS INTEGER
	BEGIN
	
		SET @quantidade = (SELECT COUNT(*) FROM alunos_disciplinas WHERE cod_disciplina = codigo_disciplina AND situacao(n1, n2, n3, n4) = situacao);/*contando a quantidade de alunos que fazem essa disciplina que estão nessa situação*/
	
	RETURN @quantidade;/*retornando essa quantidade*/
	END $$

/*Function cont_situacao_aluno
Conta a quantidade de aprovações, reprovações ou recuperações que esse aluno possui*/
CREATE FUNCTION cont_situacao_aluno(matricula_aluno INTEGER, situacao VARCHAR(12))
RETURNS INTEGER
	BEGIN

		SET @quantidade = (SELECT COUNT(*) FROM alunos_disciplinas WHERE matr_aluno = matricula_aluno AND situacao(n1, n2, n3, n4) = situacao);/*contando a quantidade de disciplinas que ele está nessa situação*/

	RETURN @quantidade;/*retornando essa quantidade*/
	END $$

/*Function valida_nota
Verifica se a nota é válida, se é um valor de 0 a 10*/
CREATE FUNCTION valida_nota(nota DOUBLE)
RETURNS BOOLEAN
	BEGIN
	
		IF(nota >= 0 AND nota <= 10)THEN/*se a nota estiver entre 0 e 10 retorna verdadeiro*/
		
			SET @retorno = 1;
			
		ELSE/*se a nota não estiver entre 0 e 10 retorna falso*/
		
			SET @retorno = 0;
			
		END IF;/*fim se a nota estiver entre 0 e 10*/
		
	RETURN @retorno;/*retornando resultado*/
	END $$

DELIMITER ;



/*Criando procedures*/

DELIMITER $$

/*Procedure insert_aluno
Insere um novo aluno no sistema*/
CREATE PROCEDURE insert_aluno(nome_aluno VARCHAR(60))
BEGIN

	SET @nome_existe = (SELECT COUNT(*) FROM alunos WHERE nome = nome_aluno);/*verifica se esse nome já está em uso*/

	IF(@nome_existe > 0)THEN/*se esse nome já está em uso ocorrerá um erro e o aluno não vai ser inserido*/
	
		SELECT "Erro, esse aluno já está registrado!" AS MSG;
	
	ELSE/*se esse nome não está registrado o aluno será inserido*/
	
		INSERT INTO alunos(nome)
			VALUES(nome_aluno);/*inserindo um novo aluno no sistema*/
			
		SELECT "Aluno inserido com sucesso!" AS MSG;
		
	END IF;/*fim se esse nome já está em uso*/

END $$

/*Procedure insert_disciplina
Insere uma nova disciplina no sistema*/
CREATE PROCEDURE insert_disciplina(nome_disciplina VARCHAR(60))
BEGIN

	SET @nome_existe = (SELECT COUNT(*) FROM disciplinas WHERE nome = nome_disciplina);/*verifica se esse nome já está em uso*/

	IF(@nome_existe > 0)THEN/*se esse nome já está em uso ocorrerá um erro*/
	
		SELECT "Erro, essa disciplina já está registrada!" AS MSG;
		
	ELSE/*se esse nome não está em uso a disciplina será inserida*/
	
		INSERT INTO disciplinas(nome)
			VALUES(nome_disciplina);/*inserindo uma nova disciplina no sistema*/
			
		SELECT "Disciplina inserida com sucesso!" AS MSG;
		
	END IF;/*fim se esse nome já está em uso*/

END $$

/*Procedure insert_aluno_disciplina
Insere um novo boletim de um aluno com uma disciplina e suas notas*/
CREATE PROCEDURE insert_aluno_disciplina(matricula_aluno INTEGER, codigo_disciplina INTEGER, nota1 DOUBLE, nota2 DOUBLE, nota3 DOUBLE, nota4 DOUBLE)
BEGIN

	SET @aluno_existe = (SELECT COUNT(*) FROM alunos WHERE matricula = matricula_aluno);/*verifica se esse aluno está cadastrado no sistema*/

	IF(@aluno_existe = 0)THEN/*se esse aluno não existe no sistema ocorrerá um erro*/
	
		SELECT "Erro, aluno não encontrado!" AS MSG;
		
	END IF;/*fim se esse aluno existe no sistema*/
	
	SET @disciplina_existe = (SELECT COUNT(*) FROM disciplinas WHERE codigo = codigo_disciplina);/*verifica se essa disciplina está cadastrada no sistema*/
	
	IF(@disciplina_existe = 0)THEN/*se essa disciplina não existe no sistema ocorrerá um erro*/
	
		SELECT "Erro, disciplina não encontrada!" AS MSG;
		
	END IF;/*fim se essa disciplina existe no sistema*/
	
	SET @nota1_valida = valida_nota(nota1);/*verifica se a nota 1 é válida*/
	
	IF(@nota1_valida = 0)THEN/*se a nota 1 não é válida ocorrerá um erro*/
	
		SELECT "Erro, nota 1 inválida digite um valor entre 0 e 10!" AS MSG;
		
	END IF;/*fim se a nota 1 é inválida*/
	
	SET @nota2_valida = valida_nota(nota2);/*verifica se a nota 2 é válida*/
	
	IF(@nota2_valida = 0)THEN/*se a nota 2 não é válida ocorrerá um erro*/
	
		SELECT "Erro, nota 2 inválida digite um valor entre 0 e 10!" AS MSG;
		
	END IF;/*fim se a nota 2 é inválida*/
	
	SET @nota3_valida = valida_nota(nota3);/*verifica se a nota 3 é válida*/
	
	IF(@nota3_valida = 0)THEN/*se a nota 3 não é válida ocorrerá um erro*/
	
		SELECT "Erro, nota 3 inválida digite um valor entre 0 e 10!" AS MSG;
		
	END IF;/*fim se a nota 3 é inválida*/
	
	SET @nota4_valida = valida_nota(nota4);/*verifica se a nota 4 é válida*/
	
	IF(@nota4_valida = 0)THEN/*se a nota 4 não é válida ocorrerá um erro*/
	
		SELECT "Erro, nota 4 inválida digite um valor entre 0 e 10!" AS MSG;
		
	END IF;/*fim se a nota 4 é inválida*/
	
	IF(@aluno_existe > 0 AND @disciplina_existe > 0 AND @nota1_valida = 1 AND @nota2_valida = 1 AND @nota3_valida = 1 AND @nota4_valida = 1)THEN/*se todos os dados são válidos o boletim será inserido*/
	
		INSERT INTO alunos_disciplinas(matr_aluno, cod_disciplina, n1, n2, n3, n4)
			VALUES(matricula_aluno, codigo_disciplina, nota1, nota2, nota3, nota4);/*inserindo o novo boletim*/
			
		SELECT "Boletim inserido com sucesso!" AS MSG;
		
	ELSE/*se os dados não são válidos ocorrerá um erro*/
	
		SELECT "Erro, boletim não inserido!" AS MSG;
		
	END IF;/*fim se os dados são válidos*/ 

END $$

/*Procedure update_aluno
Atualiza od dados do aluno*/
CREATE PROCEDURE update_aluno(matricula_aluno INTEGER, nome_aluno VARCHAR(60))
BEGIN

	SET @matricula_existe = (SELECT COUNT(*) FROM alunos WHERE matricula = matricula_aluno);/*verifica se essa matricula existe*/
	
	IF(@matricula_existe > 0)THEN/*se essa matricula existe no sistema*/
	
		SET @nome_existe = (SELECT COUNT(*) FROM alunos WHERE nome = nome_aluno AND matricula != matricula_aluno);/*verifica se esse nome não está sendo usado por outro aluno*/
	
		IF(@nome_existe > 0)THEN/*se esse nome já está sendo usado por outro aluno então ocorrerá um erro*/
		
			SELECT "Erro, esse nome já está sendo usado por outro aluno!" AS MSG;
		
		ELSE/*se esse nome está livre*/
		
			UPDATE alunos SET nome = nome_aluno WHERE matricula = matricula_aluno;/*atualizando os dados do aluno*/
			
			SELECT "Aluno atualizado com sucesso!" AS MSG;
		
		END IF;/*fim se esse nome está sendo usado por outro aluno*/
	
	ELSE/*se essa matricula não existe no sistema*/
	
		SELECT "Erro, matricula não encontrada!" AS MSG;
	
	END IF;/*fim se essa matricula existe no sistema*/

END $$

/*Procedure update_disciplina
Atualiza os dados da disciplina*/
CREATE PROCEDURE update_disciplina(codigo_disciplina INTEGER, nome_disciplina VARCHAR(60))
BEGIN

	SET @codigo_existe = (SELECT COUNT(*) FROM disciplinas WHERE codigo = codigo_disciplina);/*verifica se esse código está registrado*/

	IF(@codigo_existe > 0)THEN/*se esse código de disciplina existe no sistema*/
	
		SET @nome_existe = (SELECT COUNT(*) FROM disciplinas WHERE nome = nome_disciplina AND codigo != codigo_disciplina);/*verifica se já existe outra disciplina com esse nome*/
	
		IF(@nome_existe > 0)THEN/*se esse nome já está registrado ocorrerá um erro*/
	
			SELECT "Erro, esse nome de disciplina já está registrado!" AS MSG;
			
		ELSE/*se esse nome não estiver registrado*/

			UPDATE disciplinas SET nome = nome_disciplina WHERE codigo = codigo_disciplina;/*atualizando os dados das disciplinas*/
		
			SELECT "Disciplina atualizada com sucesso!" AS MSG;
			
		END IF;/*fim se esse nome já está registrado*/
	
	ELSE/*se esse código de disciplina não existe no sistema*/
	
		SELECT "Erro, código inválido!" AS MSG;
	
	END IF;/*fim se esse código existe no sistema*/

END $$

/*Procedure update_aluno_disciplina
Atualiza os dados do boletim do aluno com determinada disciplina*/
CREATE PROCEDURE update_aluno_disciplina(chave INTEGER, nota1 DOUBLE, nota2 DOUBLE, nota3 DOUBLE, nota4 DOUBLE)
BEGIN

	SET @id_existe = (SELECT COUNT(*) FROM alunos_disciplinas WHERE id = chave);/*verifica se esse id é válido*/
	
	IF(@id_existe = 0)THEN/*se o id for inválido ocorrerá um erro*/
	
		SELECT "Erro, boletim inválido!" AS MSG;
	
	END IF;/*fim se o id for inválido*/
	
	SET @nota1_valida = valida_nota(nota1);/*verifica se a nota 1 é válida*/
	
	IF(@nota1_valida = 0)THEN/*se a nota 1 não é válida ocorrerá um erro*/
	
		SELECT "Erro, nota 1 inválida digite um valor entre 0 e 10!" AS MSG;
		
	END IF;/*fim se a nota 1 é inválida*/
	
	SET @nota2_valida = valida_nota(nota2);/*verifica se a nota 2 é válida*/
	
	IF(@nota2_valida = 0)THEN/*se a nota 2 não é válida ocorrerá um erro*/
	
		SELECT "Erro, nota 2 inválida digite um valor entre 0 e 10!" AS MSG;
		
	END IF;/*fim se a nota 2 é inválida*/
	
	SET @nota3_valida = valida_nota(nota3);/*verifica se a nota 3 é válida*/
	
	IF(@nota3_valida = 0)THEN/*se a nota 3 não é válida ocorrerá um erro*/
	
		SELECT "Erro, nota 3 inválida digite um valor entre 0 e 10!" AS MSG;
		
	END IF;/*fim se a nota 3 é inválida*/
	
	SET @nota4_valida = valida_nota(nota4);/*verifica se a nota 4 é válida*/
	
	IF(@nota4_valida = 0)THEN/*se a nota 4 não é válida ocorrerá um erro*/
	
		SELECT "Erro, nota 4 inválida digite um valor entre 0 e 10!" AS MSG;
		
	END IF;/*fim se a nota 4 é inválida*/
	
	IF(@id_existe > 0 AND @nota1_valida = 1 AND @nota2_valida = 1 AND @nota3_valida = 1 AND @nota4_valida = 1)THEN/*se os dados são válidos*/

		UPDATE alunos_disciplinas SET n1 = nota1, n2 = nota2, n3 = nota3, n4 = nota4 WHERE id = chave;/*atualizando os dados do boletim*/

		SELECT "Boletim atualizado com sucesso!" AS MSG;
		
	ELSE/*se os dados não são válidos ocorrerá um erro*/
	
		SELECT "Erro, dados inválidos!" AS MSG;
	
	END IF;/*fim se esses dados são válidos*/

END $$

/*Procedure delete_aluno
Deleta um aluno da tabela alunos*/
CREATE PROCEDURE delete_aluno(matricula_aluno INTEGER)
BEGIN

	SET @matricula_valida = (SELECT COUNT(*) FROM alunos WHERE matricula = matricula_aluno);/*verifica se essa matricula é válida*/
	
	IF(@matricula_valida > 0)THEN/*se essa matricula é válida o aluno será deletado*/
	
		DELETE FROM alunos WHERE matricula = matricula_aluno;/*deletando um aluno*/
		
		SELECT "Aluno deletado com sucesso!" AS MSG;
		
	ELSE/*se a matrícula não for válida ocorrerá um erro*/
	
		SELECT "Erro, matrícula não encontrada!" AS MSG;
		
	END IF;/*fim se essa matricula é válida*/

END $$

/*Procedure delete_disciplina
Deleta uma disciplina da tabela disciplinas*/
CREATE PROCEDURE delete_disciplina(codigo_disciplina INTEGER)
BEGIN

	SET @codigo_valido = (SELECT COUNT(*) FROM disciplinas WHERE codigo = codigo_disciplina);/*verifica se esse código é válido*/
	
	IF(@codigo_valido > 0)THEN/*se esse código é válido o disciplina será deletada*/
	
		DELETE FROM disciplinas WHERE codigo = codigo_disciplina;/*deletando a disciplina*/
		
		SELECT "Disciplina deletada com sucesso!" AS MSG;
		
	ELSE/*se o código não for válido ocorrerá um erro*/
	
		SELECT "Erro, código não encontrado!" AS MSG;
		
	END IF;/*fim se esse código é válido*/

END $$

/*Procedure delete_aluno_disciplina
Deleta um boletim de um aluno com uma disciplina*/
CREATE PROCEDURE delete_aluno_disciplina(chave INTEGER)
BEGIN

	SET @id_existe = (SELECT COUNT(*) FROM alunos_disciplinas WHERE id = chave);/*verifica se essa chave é válida*/
	
	IF(@id_existe > 0)THEN/*se essa chave for válida o boletim será deletado*/

		DELETE FROM alunos_disciplinas WHERE id = chave;/*deletando um boletim*/
		
		SELECT "Boletim deletado com sucesso!" AS MSG;
		
	ELSE/*se essa chave não foi encontrada então ocorrerá um erro*/
	
		SELECT "Erro, boletim não encontrado!" AS MSG;
		
	END IF;/*fim se o boletim é válido*/

END $$

DELIMITER ;


/*Criando triggers*/

DELIMITER $$

/*Trigger tgr_delete_aluno
Deleta os boletins de um aluno que foi apagado, para que não fiquem registros apontando para um aluno que não existe mais.
Essa trigger irá disparar depois que um aluno for apagado da tabela alunos*/ 
CREATE TRIGGER tgr_delete_aluno AFTER DELETE ON alunos
FOR EACH ROW
	BEGIN
	
		DELETE FROM alunos_disciplinas WHERE matr_aluno = OLD.matricula;/*deletando os boletins desse aluno*/
	
	END $$

/*Trigger tgr_delete_disciplina
Deleta os boletins de uma disciplina que foi apagada, para que não fiquem registros apontando para uma disciplina que não existe mais.
Essa trigger irá disparar depois que uma disciplina for apagada da tabela disciplinas*/
CREATE TRIGGER tgr_delete_disciplina AFTER DELETE ON disciplinas
FOR EACH ROW
	BEGIN
	
		DELETE FROM alunos_disciplinas WHERE cod_disciplina = OLD.codigo;/*deletando os boletins dessa disciplina*/
	
	END $$

DELIMITER ;


/*Criando views*/

/*View vvw_alunos
Mostra a matricula, nome, quantidade de disciplinas que ele cursa, quantidade de aprovações que ele possui, quantidade de reprovações que ele possui e quantidade de recuperações que cada aluno possui*/
CREATE VIEW vw_alunos AS SELECT matricula, nome AS aluno, cont_disciplinas(matricula) AS disciplinas, cont_situacao_aluno(matricula, "Aprovado") AS aprovacoes, cont_situacao_aluno(matricula, "Reprovado") AS reprovacoes, cont_situacao_aluno(matricula, "Recuperação") AS recuperacoes FROM alunos;

/*View vw_disciplinas
Mostra o código, nome, quantidade de alunos que fazem a disciplina, quantidade de aprovações, quantidade de reprovações e quantidade de recuperações de cada disciplina*/ 
CREATE VIEW vw_disciplinas AS SELECT codigo, nome AS disciplina, cont_alunos(codigo) AS alunos, cont_situacao_disciplina(codigo, "Aprovado") AS aprovados, cont_situacao_disciplina(codigo, "Reprovado") AS reprovados, cont_situacao_disciplina(codigo, "Recuperação") AS recuperacao FROM disciplinas;

/*View vw_disciplinas
Mostra o id, matricula do aluno, aluno, codigo da disciplina, disciplina, nota 1, nota 2, nota 3, nota 4, media das notas e a situação do aluno na disciplina de cada boletim*/
CREATE VIEW vw_boletins AS SELECT id, matr_aluno AS matricula, alunos.nome AS aluno, cod_disciplina AS codigo, disciplinas.nome AS disciplina, n1 AS nota1, n2 AS nota2, n3 AS nota3, n4 AS nota4, media(n1, n2, n3, n4) AS media, situacao(n1, n2, n3, n4) AS situacao FROM alunos_disciplinas
INNER JOIN alunos ON matr_aluno = alunos.matricula
INNER JOIN disciplinas ON cod_disciplina = disciplinas.codigo;


/*Inserindo registros através das procedures*/

/*Inserindo alunos*/
CALL insert_aluno("Renato Rodrigues");
CALL insert_aluno("Evelin dos Santos");
CALL insert_aluno("José Raimundo");
CALL insert_aluno("Carlos Nascimento");
CALL insert_aluno("Vanessa Cristina");
CALL insert_aluno("Beto de Sousa");
CALL insert_aluno("Ana Paula da Silva");

/*Inserindo disciplinas*/
CALL insert_disciplina("Algoritmo e Estrutura de Dados I");
CALL insert_disciplina("Matemática Instrumental");
CALL insert_disciplina("Geometria Analítica");
CALL insert_disciplina("Cálculo I");
CALL insert_disciplina("Engenharia de Software I");
CALL insert_disciplina("Banco de Dados II");

/*Inserindo registros na tabela alunos_disciplinas (boletins)*/
CALL insert_aluno_disciplina(1, 1, 7, 7.5, 8, 9.5);
CALL insert_aluno_disciplina(2, 2, 7, 6, 5, 7);
CALL insert_aluno_disciplina(3, 2, 6, 5, 7, 4);
CALL insert_aluno_disciplina(1, 2, 8, 7.5, 6, 7);
CALL insert_aluno_disciplina(1, 3, 7, 6, 6.5, 7);
CALL insert_aluno_disciplina(4, 3, 8, 9, 7, 7.5);
CALL insert_aluno_disciplina(6, 4, 7, 5, 6, 6.5);
