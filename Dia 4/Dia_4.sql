-- #####################
-- ### DIA # 4 - RELACIONAMIENTO DE CONSULTAS ###
-- #####################


create database Dia4_CeballosKenneth;

use Dia4_CeballosKenneth;

CREATE TABLE pais (
    id INT PRIMARY KEY,
    nombre VARCHAR(20),
    continente VARCHAR(50),
    poblacion INT
);

CREATE TABLE ciudad (
    id INT PRIMARY KEY,
    nombre VARCHAR(20),
    id_pais INT,
    FOREIGN KEY (id_pais) REFERENCES pais(id)
);

CREATE TABLE idioma (
    id INT PRIMARY KEY,
    idioma VARCHAR(50)
);

CREATE TABLE idioma_pais (
    id_idioma INT,
    id_pais INT,
    es_oficial TINYINT(1),
    PRIMARY KEY (id_idioma, id_pais),
    FOREIGN KEY (id_idioma) REFERENCES idioma(id),
    FOREIGN KEY (id_pais) REFERENCES pais(id)
);

INSERT INTO pais (id, nombre, continente, poblacion) VALUES 
(1, 'España', 'Europa', 47000000),
(2, 'México', 'América', 126000000),
(3, 'Japón', 'Asia', 126300000);

INSERT INTO ciudad (id, nombre, id_pais) VALUES 
(1, 'Madrid', 1),
(2, 'Barcelona', 1),
(3, 'Ciudad de México', 2),
(4, 'Guadalajara', 2),
(5, 'Tokio', 3),
(6, 'Osaka', 3);

INSERT INTO idioma (id, idioma) VALUES 
(1, 'Español'),
(2, 'Catalán'),
(3, 'Inglés'),
(4, 'Japonés');


INSERT INTO idioma_pais (id_idioma, id_pais, es_oficial) VALUES 
(1, 1, 1), -- Español es oficial en España
(2, 1, 1), -- Catalán es oficial en España
(1, 2, 1), -- Español es oficial en México
(4, 3, 1), -- Japonés es oficial en Japón
(3, 1, 0), -- Inglés no es oficial en España
(3, 2, 0), -- Inglés no es oficial en México
(3, 3, 0); -- Inglés no es oficial en Japón