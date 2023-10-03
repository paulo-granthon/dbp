create table if not exists funcionario (
    fun_cod serial not null,
    fun_name varchar(100) not null,
    fun_cpf varchar(15) unique,
    fun_wage decimal(4, 2),
    fun_address varchar(252),
    fun_sex char(1),
    fun_cod_super integer,
    fun_cod_depart integer,
    constraint pk_funcionario_fun_cod primary key (fun_cod),
    constraint fk_functionario_fun_cod_super foreign key (fun_cod_super) references funcionario(fun_cod_super),
    constraint fk_functionario_fun_cod_depart foreign key (fun_cod_depart) references departamento(fun_cod_depart)
);

create table if not exists departamento (
    dep_cod serial not null,
    dep_name varchar(30) not null,
    dep_initial_date date,
    constraint pk_departamento_dep_cod primary key (dep_cod)
);

create table if not exists localizacao (
    loc_local varchar(252) not null,
    loc_cod_depart integer not null,
    constraint pk_localizacao_loc_local primary key (loc_local),
    constraint fk_localizacao_loc_cod_depart foreign key (loc_cod_depart) references departamento(loc_cod_depart)
);


