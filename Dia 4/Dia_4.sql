Create database Dia4_CeballosKenneth;

use Dia4_CeballosKenneth;

CREATE TABLE pais (
    id INT PRIMARY KEY not null auto_increment,
    nombre VARCHAR(20),
    continente VARCHAR(50),
    poblacion INT
);

CREATE TABLE ciudad (
    id INT PRIMARY KEY not null auto_increment,
    nombre VARCHAR(20),
    id_pais INT,
    FOREIGN KEY (id_pais) REFERENCES pais(id)
);

CREATE TABLE idioma (
    id INT PRIMARY KEY not null auto_increment,
    idioma VARCHAR(50)
);

CREATE TABLE idioma_pais (
    id_idioma INT not null,
    id_pais INT not null,
    primary key(id_idioma,id_pais),
    es_oficial TINYINT(1),
    FOREIGN KEY (id_idioma) REFERENCES idioma(id),
    FOREIGN KEY (id_pais) REFERENCES pais(id)
);

show tables; 
