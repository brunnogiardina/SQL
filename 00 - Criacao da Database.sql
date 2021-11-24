create table departamentos (
    departamento varchar(100),
    divisao varchar(100),
    primary key (departamento)
  );

insert into departamentos values ('Automotivo','Auto & Hardware');
insert into departamentos values ('Bebês','Casa e Afins');
insert into departamentos values ('Beleza','Casa e Afins');
insert into departamentos values ('Roupas','Casa e Afins');
insert into departamentos values ('Computadores','Equipamentos Eletrônicos');
insert into departamentos values ('Eletronicos','Equipamentos Eletrônicos');
insert into departamentos values ('Games','Casa e Afins');
insert into departamentos values ('Jardim','Outdoors & Jardim');
insert into departamentos values ('Alimentícios','Casa e Afins');
insert into departamentos values ('Saúde','Casa e Afins');
insert into departamentos values ('Lar','Casa e Afins');
insert into departamentos values ('Industrial','Auto & Hardware');
insert into departamentos values ('Joalheria','Fashion');
insert into departamentos values ('Crianças','Casa e Afins');
insert into departamentos values ('Filmes','Entretenimento');
insert into departamentos values ('Música','Entretenimento');
insert into departamentos values ('Outdoors','Outdoors & Jardim');
insert into departamentos values ('Calçados','Casa e Afins');
insert into departamentos values ('Esporte','Games & Esporte');
insert into departamentos values ('Ferramentas','Auto & Hardware');
insert into departamentos values ('Brinquedos','Games & Esporte');


create table localizacao (
   idRegiao int,
   localizacao varchar(20),
   pais varchar(20),
   primary key (idRegiao)
  );

insert into localizacao values (1, 'Nordeste', 'Brasil');
insert into localizacao values (2, 'Sudeste', 'Brasil');
insert into localizacao values (3, 'Sul', 'Brasil');
insert into localizacao values (4, 'Norte', 'Brasil');
insert into localizacao values (5, 'British Columbia', 'Canada');
insert into localizacao values (6, 'Quebec', 'Canada');
insert into localizacao values (7, 'Nova Scotia', 'Canada');


create table funcionarios
  (
      idFuncionario integer,
      nome varchar(100),
      email varchar(200),
      sexo varchar(10),
      departamento varchar(100),
      admissao date,
      salario integer,
      cargo varchar(100),
      idRegiao int,
      primary key (idFuncionario)
  );
