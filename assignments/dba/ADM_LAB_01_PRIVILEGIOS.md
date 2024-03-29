# Roteiro Laboratório para Admnistração de Usuários

## Instruções de execução

Cada item do experimento deve ser executado e o seu resultado documentado no relatório.

## Objetivo do laboratório

Conhecer e estudar as visões do dicionários de dados e os comandos do Oracle que gerenciam os privilégios dos usuários. Algumas

Visões do dicionário serão utilizadas para tal

Para este laboratório, o objetivo é proporcionar ao aluno o entendimento dos comandos apresentados abaixo. Por isso os comandos devem ser pesquisados na documentação do oracle e explicados no relatório.

### conecte com o usuario SYSTEM

```sql
sqplus sys as sysdba
```

-- Conexão com o usuário SYSTEM efetuada no banco `oracle-enterprise` versão 21c rodando em um container Docker via docker-compose.

![img1](/assignments/dba/img/1_connect_sysdba.png)

### Explique a finalidade da visão v$version

```sql
SELECT * FROM v$version;
```

-- A visão `v$version` é uma visão do dicionário de dados que exibe a versão do banco de dados Oracle que está sendo utilizada.

![img2](/assignments/dba/img/2_version.png)

### Explique a finalidade da visão dba_users

```sql
SELECT username FROM dba_users;

CREATE USER USR_LAB01 IDENTIFIED BY SENHA default tablespace users quota unlimited on users; 
```

-- A visão `dba_users` é uma visão do dicionário de dados que exibe informações sobre os usuários existentes no banco de dados Oracle.

![img3](/assignments/dba/img/3_dba_users.png)

-- O comando `CREATE USER` cria um novo usuário no banco de dados Oracle. O comando acima cria o usuário `USR_LAB01` com a senha `SENHA`, definindo o `tablespace` padrão como `users` e sem limitação de espaço.
Durante a execução do comando, o seguinte erro foi retornado:

```command
ORA-65096: invalid common user or role name in oracle
```

Para corrigir o erro, executei o comando abaixo:

```sql
alter session set "_ORACLE_SCRIPT"=true;
```

E então executei novamente o comando `CREATE USER` para criar o usuário `USR_LAB01`.

![img4](/assignments/dba/img/4_create_user.png)

### Explique pela documentação da oracle a finalidade das roles connect e resource

```sql
GRANT CONNECT, RESOURCE to USR_LAB01;
```

-- As roles `CONNECT` e `RESOURCE` são roles pré-definidas no Oracle Database que concedem privilégios específicos para os usuários.

- A role `CONNECT` concede ao usuário o privilégio de se conectar ao banco de dados.
- A role `RESOURCE` concede ao usuário o privilégio de criar objetos no banco de dados, como tabelas, índices, sequências, entre outros.

![img5](/assignments/dba/img/5_grant_connect_resource.png)

### Abra outra janela e conecte com o usuário criado acima. Foi possível conectar?

-- Sim, foi possível conectar com o usuário `USR_LAB01` criado anteriormente ao utilizar a senha `SENHA`.

![img6](/assignments/dba/img/6_connect_usr_lab01.png)

### Execute o comando abaixo na janela conectado como SYSTEM

```sql
ALTER USER USR_LAB01 IDENTIFIED BY new_password;
```

## Volte na janela do usuário criado e verifique se ele continua conectado através do comando abaixo

```sql
select table_name from all_tables;
```

-- O comando `ALTER USER` foi executado com sucesso, alterando a senha do usuário `USR_LAB01` para `new_password`.  
-- Em seguida, executei o comando `select table_name from all_tables;` para verificar se o usuário `USR_LAB01` ainda estava conectado.  
-- O comando retornou a tabela `ALL_TABLES` com as informações das tabelas existentes no banco de dados.  
-- Constatando que o usuário `USR_LAB01` continuou conectado após a alteração da senha.  

![img7](/assignments/dba/img/7_alter_user.png)

### Encerre a conexão dessa janela e tente conectar novamente usando a mesma senha. Você conseguiu conectar?

-- Não foi possível conectar novamente com o usuário `USR_LAB01` utilizando a senha anterior `SENHA`, pois a senha foi alterada para `new_password`.

![img8](/assignments/dba/img/8_connect_usr_lab01_fail.png)

### Tente usar a nova senha alterada no comando ALTER USER. O que aconteceu?

-- Após tentar conectar com a nova senha `new_password`, foi possível acessar o usuário `USR_LAB01` com sucesso.

![img9](/assignments/dba/img/9_connect_usr_lab01_new_password.png)

### A partir da janela do usuário system execute os comandos abaixo

```sql
SHOW USER;
```

-- O comando `SHOW USER` exibe o nome do usuário conectado no momento, que no caso é o usuário `SYS`.

### Esse comando cria a tabela xyz em qual usuário?

```sql
CREATE TABLE xyz (name VARCHAR2(30));
```

-- O comando `CREATE TABLE xyz (name VARCHAR2(30));` cria a tabela `xyz` no usuário conectado, que no caso é o usuário `SYS`.

### E esse? Cria a tabela xyz em qual usuário?

```sql
CREATE TABLE USR_LAB01.xyz (name VARCHAR2(30));
```

-- O comando `CREATE TABLE USR_LAB01.xyz (name VARCHAR2(30));` cria a tabela `xyz` no usuário `USR_LAB01`.

### Que nível de privilégio foi necessário para que isso seja possível?

-- Para que o usuário `SYS` possa criar uma tabela no usuário `USR_LAB01`, é necessário que o usuário `SYS` possua o privilégio `CREATE ANY TABLE`.

### Volte na janela do usuário USR_LAB01 e rode o comando abaixo

### Se ele funcionar é que a tabela pertence a esse usuário

```sql
DESC xyz 
```

### Esse comando funcionou? O que falta ao usuário USR_LAB01 para que esse comando funcione?

-- O comando `DESC xyz` exibe o seguinte erro: `ORA-04043: object xyz does not exist`.

```sql
DESC system.xyz
```

-- O comando `DESC system.xyz` exibe o seguinte erro: `ORA-04043: object system.xyz does not exist`.

## Volte na janela do usuário SYSTEM

```sql
CREATE USER USR_LAB02 IDENTIFIED BY SENHA default tablespace users;
```

### Que operação está acontecendo aqui?

```sql
GRANT INSERT, DELETE, SELECT ON USR_LAB01.XYZ TO USR_LAB02;

GRANT connect to USR_lab02;
```

-- O comando `CREATE USER` cria um novo usuário no banco de dados Oracle. O comando acima cria o usuário `USR_LAB02` com a senha `SENHA`, definindo o `tablespace` padrão como `users`.

### Qual o significado do resultado dessa consulta?

```sql
select * from dba_tab_privs where grantee = 'USR_LAB02';
```

-- O comando `select * from dba_tab_privs where grantee = 'USR_LAB02';` exibe as permissões concedidas ao usuário `USR_LAB02` sobre as tabelas do banco de dados.

## Abra uma nova janela e conecte com o usuário usr_lab02. Execute o comando abaixo

```sql
insert into usr_lab01.xyz values ('teste de nome');

commit;
```

### Mostre o resultado desse comando e explique por que ele funcionou.

```sql
select * from usr_lab01.xyz;
```

### Mostre o resultado desse comando e explique por que ele NÃO funcionou.

```sql
select * from system.xyz;
```

### Mostre o resultado desse comando e explique por que ele NÃO funcionou.

```sql
select * from xyz;
```

## Na janela do usuário usr_lab01

### A visão dba_sys_privs requer privilégio específico para ser acessada. O usuário usr_lab01 ainda não tem esse privilégio. rode o comando abaixo e veja se funciona?

```sql
select * from dba_sys_privs;
```

## Na janela do usuário system

```sql
CREATE ROLE new_dba;

GRANT CONNECT TO new_dba;

GRANT SELECT ANY TABLE TO new_dba;

GRANT select_catalog_role TO new_dba;

grant new_dba to USR_LAB01;
```

## Na janela do usuário usr_lab01

- Refaça a sua conexão para garantir que os privilégios tenham sido atualizados.
- Execute o comando e veja que ele funciona.
- Explique como foi o processo de atribuição do privilégio ao usuário usr_lab01 que permitiu a ele acessa a tabela.

### Através das views a seguir, exibir os privilégios dos usuários e roles criados nesse lab.
select * from dba_sys_privs;

```sql
SELECT * FROM DBA_ROLE_PRIVS;
SELECT * FROM ROLE_ROLE_PRIVS;
SELECT * FROM ROLE_SYS_PRIVS;
SELECT * FROM ROLE_TAB_PRIVS;
```

## Esses comandos são para quem está utilizando o oracle express versão 10.

```bash
lsnrctl
set path=C:\oraclexe\app\oracle\product\11.2.0\server\bin;%path%
```

Dentro do lsnrctl usar o comando status para verificar a disponibilidade do banco de dados

```bash
netstat -a # verifica as portas disponíveis no computador
sqlplus /nolog # abre o sqlplus sem pedir login
```

Dentro do sqlplus, digitar conn user/senha para fazer o login desejado
