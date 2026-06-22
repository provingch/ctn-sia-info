##information_schema|mysql|performance_schema|phpmyadmin

drop database if exists ctndb;
create database ctndb;
use ctndb;

CREATE TABLE especialidad (
    id INT,
    nombre VARCHAR(45) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE curso (
    id INT AUTO_INCREMENT,
    especialidad_id INT NOT NULL,
    promocion SMALLINT UNSIGNED NOT NULL,
    seccion enum('A', 'B', 'C') NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (especialidad_id , promocion , seccion),
    CONSTRAINT fk_curso_especialidad FOREIGN KEY (especialidad_id)
        REFERENCES especialidad (id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE alumno (
    id INT AUTO_INCREMENT,
    ci INT UNIQUE,
    nombre VARCHAR(45) NOT NULL,
    apellido VARCHAR(45) NOT NULL,
    curso_id INT NOT NULL,
    correo_encargado VARCHAR(45),
    correo_encargado2 VARCHAR(45),
    PRIMARY KEY (id),
    FOREIGN KEY (curso_id)
        REFERENCES curso (id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE profesor (
    id INT AUTO_INCREMENT,
    nombre VARCHAR(45),
    apellido VARCHAR(45),
    usuario VARCHAR(45) NOT NULL UNIQUE,
    contrasenia VARCHAR(45) DEFAULT 'ctn123' NOT NULL,
    ci int UNIQUE,
    telefono int,
    celular int,
    correo VARCHAR(45),
    nivel TINYINT NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE materia (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(45) NOT NULL,
    categoria ENUM('comun', 'especifico') NOT NULL,
    especialidad_id INT,
    CONSTRAINT fk_materia_especialidad FOREIGN KEY (especialidad_id)
        REFERENCES especialidad (id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE planilla (
    id INT AUTO_INCREMENT,
    curso_id INT NOT NULL,
    materia_id INT NOT NULL,
    periodo SMALLINT UNSIGNED NOT NULL,
    etapa ENUM('primera', 'segunda') NOT NULL,
    profesor_id INT NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (curso_id, materia_id, periodo, etapa),
    FOREIGN KEY (curso_id)
        REFERENCES curso (id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (materia_id)
        REFERENCES materia (id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (profesor_id)
        REFERENCES profesor (id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE instrumento (
    id INT,
    nombre VARCHAR(45) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE tarea (
    id INT AUTO_INCREMENT PRIMARY KEY,
    planilla_id INT NOT NULL,
    instrumento_id INT NOT NULL,
    fecha DATE NOT NULL,
    total SMALLINT UNSIGNED NOT NULL,
    titulo VARCHAR(100) NOT NULL,
    FOREIGN KEY (planilla_id)
        REFERENCES planilla (id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (instrumento_id)
        REFERENCES instrumento (id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE registro (
    id INT AUTO_INCREMENT PRIMARY KEY,
    planilla_id INT NOT NULL,
    alumno_id INT NOT NULL,
    FOREIGN KEY (planilla_id)
        REFERENCES planilla (id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (alumno_id)
        REFERENCES alumno (id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE puntaje (
    registro_id CHAR,
    tarea_id INT,
    puntos SMALLINT UNSIGNED,
    PRIMARY KEY (registro_id , tarea_id),
    FOREIGN KEY (registro_id)
        REFERENCES registro (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (tarea_id)
        REFERENCES tarea (id)
        ON UPDATE CASCADE ON DELETE CASCADE
);
