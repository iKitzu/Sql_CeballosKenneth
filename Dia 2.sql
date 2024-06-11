-- #####################
-- ### DIA # 2 - Comandos Generales ###
-- #####################

-- Comando general para revisión de bases de datos creadas
show databases;

-- Crear base de datos

create database dia2;

-- Utilizar BBDD dia2

use dia2;

-- Crear tabla departamento
CREATE TABLE persona (
    id INT(10) AUTO_INCREMENT PRIMARY KEY,
    nif VARCHAR(9) NOT NULL,
    nombre VARCHAR(25) NOT NULL,
    apellido1 VARCHAR(50) NOT NULL,
    apellido2 VARCHAR(50) NOT NULL,
    ciudad VARCHAR(25),
    direccion VARCHAR(50),
    telefono VARCHAR(9),
    fecha_nacimiento DATE,
    sexo ENUM('H', 'M'),
    tipo ENUM('profesor', 'alumno') NOT NULL
);

CREATE TABLE departamento (
    id INT(10) AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE profesor (
    id_profesor INT(10) AUTO_INCREMENT PRIMARY KEY,
    id_persona INT(10) NOT NULL,
    id_departamento INT(10) NOT NULL,
    FOREIGN KEY (id_persona) REFERENCES persona(id),
    FOREIGN KEY (id_departamento) REFERENCES departamento(id)
);

CREATE TABLE grado (
    id INT(10) AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE curso_escolar (
    id INT(10) AUTO_INCREMENT PRIMARY KEY,
    anyo_inicio YEAR(4) NOT NULL,
    anyo_fin YEAR(4) NOT NULL
);

CREATE TABLE asignatura (
    id INT(10) AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    creditos FLOAT NOT NULL,
    tipo ENUM('basica','obligatoria', 'optativa') NOT NULL,
    curso TINYINT(3) NOT NULL,
    cuatrimestre TINYINT(3) NOT NULL,
    id_profesor INT(10) NOT NULL,
    id_grado INT(10) NOT NULL,
    FOREIGN KEY (id_profesor) REFERENCES profesor(id_profesor),
    FOREIGN KEY (id_grado) REFERENCES grado(id)
);

CREATE TABLE alumno_se_matricula_asignatura (
    id_alumno INT(10) NOT NULL,
    id_asignatura INT(10) NOT NULL,
    id_curso_escolar INT(10) NOT NULL,
    PRIMARY KEY (id_alumno, id_asignatura, id_curso_escolar),
    FOREIGN KEY (id_alumno) REFERENCES persona(id),
    FOREIGN KEY (id_asignatura) REFERENCES asignatura(id),
    FOREIGN KEY (id_curso_escolar) REFERENCES curso_escolar(id)
);

-- Desarrollado por Kenneth Santiago Ceballos Sierra / ID1097095601
