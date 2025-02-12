
--PARTE 1
--IMPLEMENTACIÓN DE LA BASE DE DATOS: creación de las tablas

CREATE TABLE RADIO(
    nombre VARCHAR2(120) PRIMARY KEY,
    direccion VARCHAR2(120) NOT NULL,
    web VARCHAR2(120) NOT NULL,
    telefono VARCHAR2(9) NOT NULL,
    email VARCHAR2(120) NOT NULL
);
    
CREATE TABLE EMISION(
    radio VARCHAR2(120) ,
    fechaHora DATE,
    tema VARCHAR2(120) NOT NULL,
    PRIMARY KEY(radio,fechaHora),
    CONSTRAINT C_R  FOREIGN KEY(radio) REFERENCES RADIO ON DELETE CASCADE --clave ajena a RADIO B:C M:R 
);

CREATE TABLE TEMA(
    codigo VARCHAR2(20) PRIMARY KEY,
    titulo VARCHAR2(120) NOT NULL,
    duracion NUMBER(4) NOT NULL,
    autor VARCHAR2(120) NOT NULL,
    LP NUMBER(10) NOT NULL,
    caraLP CHAR(1) NOT NULL,
    pistaLP NUMBER(2) NOT NULL,
    sencillo NUMBER(10),
    caraSencillo CHAR(1),
    pistaSencillo NUMBER(2)  
);

CREATE TABLE LP(
    ISVN NUMBER(10) PRIMARY KEY,
    titulo VARCHAR2(120) NOT NULL,
    copiasLanzamiento NUMBER(12) NOT NULL
);
CREATE TABLE SENCILLO(
    ISVN NUMBER(10) PRIMARY KEY,
    ISVNLP NUMBER(10) NOT NULL 
);
CREATE TABLE VINILO(
    ISVN NUMBER(10) PRIMARY KEY,
    fechaLanzamiento DATE NOT NULL,
    copiasVendidas NUMBER(8) NOT NULL,
    grupo VARCHAR2(120) NOT NULL, 
    discografica VARCHAR2(120)
);
CREATE TABLE RANKING(
    anyo NUMBER(4),
    semana NUMBER(2),
    primero NUMBER(10) NOT NULL,
    segundo NUMBER(10) NOT NULL,
    tercero NUMBER(10) NOT NULL,
    PRIMARY KEY(anyo,semana)  
);

CREATE TABLE GRUPO(
    nombre VARCHAR2(120) PRIMARY KEY,
    anyoFundacion NUMBER(4) NOT NULL,
    pais VARCHAR2(120) 
);

CREATE TABLE DISCOGRAFICA(
    nombre VARCHAR2(120) PRIMARY KEY,
    telefono VARCHAR2(9) NOT NULL,
    direccion VARCHAR2(120) NOT NULL,
    pais VARCHAR2(120) NOT NULL
);

ALTER TABLE EMISION
    ADD CONSTRAINT E_R FOREIGN KEY(tema) REFERENCES TEMA;--clave ajena a TEMA B:R M:R
    
ALTER TABLE TEMA
    ADD CONSTRAINT T_LP FOREIGN KEY(LP) REFERENCES LP;--clave ajena a LP B:R M:R
    
ALTER TABLE TEMA    
    ADD CONSTRAINT T_sen FOREIGN KEY(sencillo) REFERENCES SENCILLO;--clave ajena a SENCILLO B:R M:R
    
ALTER TABLE LP
    ADD CONSTRAINT LP_VIN FOREIGN KEY(ISVN) REFERENCES VINILO ON DELETE CASCADE;--CLAVE AJENA A VINILO B:C M:R

ALTER TABLE SENCILLO
    ADD CONSTRAINT SEN_VIN FOREIGN KEY(ISVN) REFERENCES VINILO ON DELETE CASCADE;--CLAVE AJENA A VINILO B:C M:R
    
ALTER TABLE SENCILLO 
    ADD CONSTRAINT SEN_LP FOREIGN KEY(ISVNLP) REFERENCES LP ON DELETE CASCADE;--CLAVE AJENA A LP B:C M:R
    
ALTER TABLE VINILO
    ADD CONSTRAINT VIN_GRUP FOREIGN KEY(grupo) REFERENCES GRUPO;--CLAVE AJENA A GRUPO B:R M:R
    
ALTER TABLE VINILO
    ADD CONSTRAINT VIN_DIS FOREIGN KEY(discografica) REFERENCES DISCOGRAFICA ON DELETE SET NULL;--CLAVE AJENA A DISCOGRAFICA B:N M:R

ALTER TABLE RANKING 
    ADD CONSTRAINT RAN_SEN1 FOREIGN KEY(primero) REFERENCES SENCILLO ON DELETE CASCADE;--CLAVE AJENA A SENCILLO B:C M:R
ALTER TABLE RANKING 
    ADD CONSTRAINT RAN_SEN2 FOREIGN KEY(segundo) REFERENCES SENCILLO ON DELETE CASCADE;--CLAVE AJENA A SENCILLO B:C M:R
ALTER TABLE RANKING 
    ADD CONSTRAINT RAN_SEN3 FOREIGN KEY(tercero) REFERENCES SENCILLO ON DELETE CASCADE;--CLAVE AJENA A SENCILLO B:C M:R    

ALTER TABLE SENCILLO --EL ISVN DE UN SENCILLO NO PUEDE SER IGUAL QUE EL LP AL QUE PERTENECE(ISVNLP)
    ADD CONSTRAINT CHECK_ISVN_DF_ISVNLP 
    CHECK(ISVN<>ISVNLP);
    
ALTER TABLE TEMA--EL MISMO AUTOR NO PUEDE COMPONER DOS TEMAS CON EL MISMO TITULO
    ADD CONSTRAINT UQ_AUTOR_TITULO
    UNIQUE(autor,titulo);
    
ALTER TABLE TEMA--LOS CAMPOS QUE IDENTIFICAN A SENCILLO, CARA Y PISTA DONDE PUEDEN ESTAR GRABADOS EN UN TEMA HAN DE SER, O LOS TRES NULOS, O LOS TRES NO NULOS
    ADD CONSTRAINT CHECK_SENCILLO_FACE_TRACK
    CHECK((sencillo IS NULL AND caraSencillo IS NULL AND pistaSencillo IS NULL) OR (sencillo IS NOT NULL AND caraSencillo IS NOT NULL AND pistaSencillo IS NOT NULL));
    
--PARTE 2: Inserción de datos y modificación del esquema

--2.1. Inserte los datos utilizando el script que tiene disponible en la página de la asignatura

--INSERCIONES

--DISCOGRAFICA
INSERT INTO DISCOGRAFICA (nombre, telefono, direccion, pais) VALUES ('RCA','123456789','C/RCA sn','Espanya');
INSERT INTO DISCOGRAFICA (nombre, telefono, direccion, pais) VALUES ('Columbia Records','123456789','Street Columbia Records','EEUU');
INSERT INTO DISCOGRAFICA (nombre, telefono, direccion, pais) VALUES ('Capitol Records','123456789','Street Capitol Records','EEUU');
INSERT INTO DISCOGRAFICA (nombre, telefono, direccion, pais) VALUES ('Sony Music','123456789','Street Sony Music Records','EEUU');
INSERT INTO DISCOGRAFICA (nombre, telefono, direccion, pais) VALUES ('Warner Bros. Records','123456789','C/Warner sn','Espanya');
INSERT INTO DISCOGRAFICA (nombre, telefono, direccion, pais) VALUES ('Epic','123456789', 'C/Epic sn','Espanya');


--RADIO
INSERT INTO RADIO (nombre, direccion, web, email, telefono) VALUES ('Radio Vaticano','Direccion Radio Vaticano','https://www.vaticannews.va/es.html','contacto@vaticannews.va','132132113');
INSERT INTO RADIO (nombre, direccion, web, email, telefono) VALUES ('Europa FM','Direccion de Onda Cero','https://www.ondacero.es','contacto@ondacero.es','132132113');
INSERT INTO RADIO (nombre, direccion, web, email, telefono) VALUES ('RNE1','Direccion de RTVE','https://www.rtve.es/rne1','contacto@rtve.es','132132113');
INSERT INTO RADIO (nombre, direccion, web, email, telefono) VALUES ('RNE3','Direccion de RTVE','https://www.rtve.es/rne3','contacto@rtve.es','132132113');
INSERT INTO RADIO (nombre, direccion, web, email, telefono) VALUES ('RNE5','Direccion de RTVE','https://www.rtve.es/rne5','contacto@rtve.es','132132113');
INSERT INTO RADIO (nombre, direccion, web, email, telefono) VALUES ('40 Principales','Direccion de la Cadena SER','https://cadenaser.com','contacto@cadenaser.com','132132113');


--GRUPO
INSERT INTO GRUPO (nombre, anyoFundacion, pais) VALUES ('AC/DC','1973','Australia');
INSERT INTO GRUPO (nombre, anyoFundacion, pais) VALUES ('Radio Futura','1979','Espanya');
INSERT INTO GRUPO (nombre, anyoFundacion, pais) VALUES ('Sidonie','1997','Espanya');
INSERT INTO GRUPO (nombre, anyoFundacion, pais) VALUES ('Queen','1970','Reino Unido');

--VINILO
INSERT INTO VINILO (ISVN, fechaLanzamiento, copiasVendidas, grupo, discografica) VALUES (1000000001,TO_DATE('25-07-1980','DD-MM-YYYY'),200000,'AC/DC','Warner Bros. Records'); -- Back in Black
INSERT INTO VINILO (ISVN, fechaLanzamiento, copiasVendidas, grupo, discografica) VALUES (1000000011,TO_DATE('25-07-1980','DD-MM-YYYY'),500000,'AC/DC','Warner Bros. Records'); -- sencillo Back in Black
INSERT INTO VINILO (ISVN, fechaLanzamiento, copiasVendidas, grupo, discografica) VALUES (2000000001,TO_DATE('01-01-1987','DD-MM-YYYY'),110000, 'Radio Futura','RCA'); -- La Cancion de Juan Perro 
INSERT INTO VINILO (ISVN, fechaLanzamiento, copiasVendidas, grupo, discografica) VALUES (2000000011,TO_DATE('01-01-1987','DD-MM-YYYY'),50000, 'Radio Futura','RCA'); -- Sencillo La Cancion de Juan Perro 
INSERT INTO VINILO (ISVN, fechaLanzamiento, copiasVendidas, grupo, discografica) VALUES (2000000111,TO_DATE('01-01-1987','DD-MM-YYYY'),15000,'Radio Futura','RCA'); -- Maxi 37 Grados
INSERT INTO VINILO (ISVN, fechaLanzamiento, copiasVendidas, grupo, discografica) VALUES (3000000001,TO_DATE('18-10-2011','DD-MM-YYYY'),310000,'Sidonie','Columbia Records'); -- El Fluido Garcia
INSERT INTO VINILO (ISVN, fechaLanzamiento, copiasVendidas, grupo, discografica) VALUES (3000000011,TO_DATE('18-10-2011','DD-MM-YYYY'),500000,'Sidonie','Columbia Records'); -- Sencillo El Fluido Garcia
INSERT INTO VINILO (ISVN, fechaLanzamiento, copiasVendidas, grupo, discografica) VALUES (3000000002,TO_DATE('01-01-2003','DD-MM-YYYY'),410000,'Sidonie','Columbia Records'); -- Shell Kids
INSERT INTO VINILO (ISVN, fechaLanzamiento, copiasVendidas, grupo, discografica) VALUES (3000000012,TO_DATE('01-01-2003','DD-MM-YYYY'),350000,'Sidonie','Columbia Records'); -- Sencillo Shell Kids
INSERT INTO VINILO (ISVN, fechaLanzamiento, copiasVendidas, grupo, discografica) VALUES (5000000001,TO_DATE('21-11-1975','DD-MM-YYYY'),610000,'Queen','Capitol Records'); -- A Night at the Opera
INSERT INTO VINILO (ISVN, fechaLanzamiento, copiasVendidas, grupo, discografica) VALUES (5000000011,TO_DATE('21-11-1975','DD-MM-YYYY'),500000,'Queen','Capitol Records'); -- Sencillo A Night at the Opera
INSERT INTO VINILO (ISVN, fechaLanzamiento, copiasVendidas, grupo, discografica) VALUES (5000000002,TO_DATE('30-06-1980','DD-MM-YYYY'),710000,'Queen','Capitol Records'); -- The Game
INSERT INTO VINILO (ISVN, fechaLanzamiento, copiasVendidas, grupo, discografica) VALUES (5000000012,TO_DATE('30-06-1980','DD-MM-YYYY'),810000,'Queen','Capitol Records'); -- Sencillo The Game
INSERT INTO VINILO (ISVN, fechaLanzamiento, copiasVendidas, grupo, discografica) VALUES (5000000003,TO_DATE('02-06-1986','DD-MM-YYYY'),500000,'Queen','Capitol Records'); -- A Kind of Magic

--LP
INSERT INTO LP (ISVN, titulo, copiasLanzamiento) VALUES (1000000001,'Back in Black',100000);
INSERT INTO LP (ISVN, titulo, copiasLanzamiento) VALUES (2000000001,'La Cancion de Juan Perro',110000);
INSERT INTO LP (ISVN, titulo, copiasLanzamiento) VALUES (3000000001,'El Fluido Garcia',310000);
INSERT INTO LP (ISVN, titulo, copiasLanzamiento) VALUES (3000000002,'Shell Kids',410000);
INSERT INTO LP (ISVN, titulo, copiasLanzamiento) VALUES (5000000001,'A Night at the Opera',610000);
INSERT INTO LP (ISVN, titulo, copiasLanzamiento) VALUES (5000000002,'The Game',710000);
INSERT INTO LP (ISVN, titulo, copiasLanzamiento) VALUES (5000000003,'A Kind of Magic',810000);


--SENCILLO 

INSERT INTO SENCILLO (ISVN, ISVNLP) VALUES (1000000011,1000000001);
INSERT INTO SENCILLO (ISVN, ISVNLP) VALUES (2000000011,2000000001);
INSERT INTO SENCILLO (ISVN, ISVNLP) VALUES (2000000111,2000000001);
INSERT INTO SENCILLO (ISVN, ISVNLP) VALUES (3000000011,3000000001);
INSERT INTO SENCILLO (ISVN, ISVNLP) VALUES (3000000012,3000000002);
INSERT INTO SENCILLO (ISVN, ISVNLP) VALUES (5000000011,5000000001);
INSERT INTO SENCILLO (ISVN, ISVNLP) VALUES (5000000012,5000000002);

--TEMA
INSERT INTO TEMA (codigo, titulo, duracion,autor, LP, caraLP, pistaLP, sencillo, caraSencillo,pistaSencillo) VALUES ('1','Back in Black',300,'AC/DC',1000000001,'A',5,1000000011,'A',1); -- Back in Black,
INSERT INTO TEMA (codigo, titulo, duracion,autor, LP, caraLP, pistaLP, sencillo, caraSencillo,pistaSencillo) VALUES ('2','La Cancion de Juan Perro',301,'Radio Futura',2000000001,'A',1,2000000011,'A',1); -- La Cancion de Juan Perro 
INSERT INTO TEMA (codigo, titulo, duracion,autor, LP, caraLP, pistaLP, sencillo, caraSencillo,pistaSencillo) VALUES ('4','Carnaval',303,'Sidonie', 3000000001,'A',4,3000000011,'A',1); -- El Fluido Garcia
INSERT INTO TEMA (codigo, titulo, duracion,autor, LP, caraLP, pistaLP, sencillo, caraSencillo,pistaSencillo) VALUES ('5','On the Sofa',304,'Sidonie',3000000002,'A',2,3000000012,'A',1); -- Shell Kids
INSERT INTO TEMA (codigo, titulo, duracion,autor, LP, caraLP, pistaLP, sencillo, caraSencillo,pistaSencillo) VALUES ('7','Bohemian Rhapsody',306,'Queen',5000000001,'A',1,5000000011,'A',1); -- A Night at the Opera
INSERT INTO TEMA (codigo, titulo, duracion,autor, LP, caraLP, pistaLP, sencillo, caraSencillo,pistaSencillo) VALUES ('8','Another One Bites the Dust',307,'Queen',5000000002,'A',1,5000000012,'A',1); -- The Game   
INSERT INTO TEMA (codigo, titulo, duracion,autor, LP, caraLP, pistaLP, sencillo, caraSencillo,pistaSencillo) VALUES ('9','Dragon Attack',260,'Queen',5000000002,'A',2,5000000012,'B',1); -- Otra canci n en el sencillo de The Game   

--EMISION
INSERT INTO EMISION (radio, fechaHora, tema) VALUES ('Europa FM',to_date('01-01-1981 08:03:01','DD-MM-YYYY HH24:MI:SS'),'2'); -- Europa FM emite solo musica espanyola
INSERT INTO EMISION (radio, fechaHora, tema) VALUES ('Europa FM',to_date('01-03-1981 08:03:01','DD-MM-YYYY HH24:MI:SS'),'4');
INSERT INTO EMISION (radio, fechaHora, tema) VALUES ('Europa FM',to_date('01-04-1981 08:03:01','DD-MM-YYYY HH24:MI:SS'),'5');
INSERT INTO EMISION (radio, fechaHora, tema) VALUES ('Europa FM',to_date('01-11-1981 08:03:01','DD-MM-YYYY HH24:MI:SS'),'7');
INSERT INTO EMISION (radio, fechaHora, tema) VALUES ('RNE3',to_date('02-01-1981 08:03:01','DD-MM-YYYY HH24:MI:SS'),'1'); -- RNE3 emite solo a Sabina
INSERT INTO EMISION (radio, fechaHora, tema) VALUES ('40 Principales',to_date('03-01-1987 08:03:01','DD-MM-YYYY HH24:MI:SS'),'2'); -- 40 Principales lo emite todo, menos AC/DC
INSERT INTO EMISION (radio, fechaHora, tema) VALUES ('40 Principales',to_date('27-10-1987 09:03:01','DD-MM-YYYY HH24:MI:SS'),'4');
INSERT INTO EMISION (radio, fechaHora, tema) VALUES ('40 Principales',to_date('03-04-1987 10:03:01','DD-MM-YYYY HH24:MI:SS'),'8');
INSERT INTO EMISION (radio, fechaHora, tema) VALUES ('40 Principales',to_date('03-01-1987 11:03:01','DD-MM-YYYY HH24:MI:SS'),1);
INSERT INTO EMISION (radio, fechaHora, tema) VALUES ('40 Principales',to_date('03-02-1987 12:03:01','DD-MM-YYYY HH24:MI:SS'),'5');
INSERT INTO EMISION (radio, fechaHora, tema) VALUES ('40 Principales',to_date('03-03-1987 13:03:01','DD-MM-YYYY HH24:MI:SS'),'1');
INSERT INTO EMISION (radio, fechaHora, tema) VALUES ('40 Principales',to_date('27-10-1987 14:03:01','DD-MM-YYYY HH24:MI:SS'),'4');

--RANKING
INSERT INTO RANKING VALUES(1989,1,5000000011,1000000011,2000000011);
INSERT INTO RANKING VALUES(1989,2,5000000011,1000000011,2000000011);
INSERT INTO RANKING VALUES(1989,3,5000000011,1000000011,2000000011);
INSERT INTO RANKING VALUES(1989,4,5000000011,1000000011,2000000011);
INSERT INTO RANKING VALUES(1989,5,5000000011,1000000011,2000000011);
INSERT INTO RANKING VALUES(1989,6,1000000011,5000000011,2000000011);
INSERT INTO RANKING VALUES(1989,7,1000000011,5000000011,2000000011);
INSERT INTO RANKING VALUES(1989,8,1000000011,5000000011,2000000011);
INSERT INTO RANKING VALUES(1989,9,1000000011,5000000011,2000000011);
INSERT INTO RANKING VALUES(1989,10,1000000011,5000000011,2000000011);
INSERT INTO RANKING VALUES(1990,1,2000000111,1000000011,5000000011);
INSERT INTO RANKING VALUES(1990,2,5000000011,1000000011,2000000111);
INSERT INTO RANKING VALUES(1990,3,3000000011,1000000011,2000000011);
INSERT INTO RANKING VALUES(1990,4,5000000011,1000000011,3000000011);
INSERT INTO RANKING VALUES(1990,5,5000000011,1000000011,3000000011);

--2.2. Inserte los siguientes valores correspondientes a la cantante Rosalía:

INSERT INTO GRUPO (nombre, anyoFundacion, pais) VALUES ('Rosalia','2013','Espana');
INSERT INTO VINILO (ISVN, fechaLanzamiento, copiasVendidas, grupo, discografica) VALUES (6000000001,TO_DATE('18/03/22','DD/MM/YY'),100000,'Rosalia','Columbia Records');
INSERT INTO VINILO (ISVN, fechaLanzamiento, copiasVendidas, grupo, discografica) VALUES (6000000011,TO_DATE('04/02/22','DD/MM/YY'),25000,'Rosalia','Columbia Records');
INSERT INTO LP (ISVN, titulo, copiasLanzamiento) VALUES (6000000001,'Motomami',100000);
INSERT INTO SENCILLO (ISVN, ISVNLP) VALUES (6000000011,6000000001);
INSERT INTO TEMA (codigo, titulo, duracion,autor, LP, caraLP, pistaLP, sencillo, caraSencillo,pistaSencillo) VALUES ('10','Saoko',137,'Rosalia',6000000001,'A',1,6000000011,'A',1);
INSERT INTO TEMA (codigo, titulo, duracion,autor, LP, caraLP, pistaLP, sencillo, caraSencillo,pistaSencillo) VALUES ('11','Candy',193,'Rosalia',6000000001,'A',2,null,null,null);
INSERT INTO TEMA (codigo, titulo, duracion,autor, LP, caraLP, pistaLP, sencillo, caraSencillo,pistaSencillo) VALUES ('12','Bizcochito',109,'Rosalia',6000000001,'B',1,null,null,null);
INSERT INTO EMISION (radio, fechaHora, tema) VALUES ('40 Principales',to_date('03-04-2022 08:00:00','DD-MM-YYYY HH24:MI:SS'),'10');
INSERT INTO EMISION (radio, fechaHora, tema) VALUES ('40 Principales',to_date('27-04-2022 09:00:00','DD-MM-YYYY HH24:MI:SS'),'10');
INSERT INTO EMISION (radio, fechaHora, tema) VALUES ('40 Principales',to_date('05-05-2022 10:00:00','DD-MM-YYYY HH24:MI:SS'),'10');
INSERT INTO EMISION (radio, fechaHora, tema) VALUES ('40 Principales',to_date('06-05-2022 11:00:00','DD-MM-YYYY HH24:MI:SS'),'10');


--2.3. Añada una restricción sin nombre que compruebe que los únicos países válidos para las Discográficas son 'Espanya' y 'EEUU'
ALTER TABLE DISCOGRAFICA
ADD CONSTRAINT CHK_PAIS
CHECK (pais IN('Espanya','EEUU'));

--2.3.1.Intente actualizar los datos, cambiando a 'Francia' el nombre del país para la Discográfica RCA (incumpliendo la restricción) y compruebe el error que devuelve Oracle. Elimine la restricción y vuelva a añadirla, esta vez con nombre CK_DISC_PaisValido.
UPDATE DISCOGRAFICA--se incumple la restriccion 
SET pais='Francia'
WHERE nombre='RCA';

ALTER TABLE DISCOGRAFICA--eliminamos esa restriccion
DROP CONSTRAINT CHK_PAIS;

ALTER TABLE DISCOGRAFICA--añadir de nuevo la restriccion con otro nombre
ADD CONSTRAINT CHK_DISC_PaisValido
CHECK (pais IN('Espanya','EEUU'));

--2.3.2.Actualice los datos de modo que no se cumpla la restricción y compruebe las diferencias.
SELECT * FROM DISCOGRAFICA;


--2.4. Añada la restricción de que dos emisoras de radio no pueden tener la misma URL (web).
ALTER TABLE RADIO
ADD CONSTRAINT UQ_WEB UNIQUE(web);

--2.4.1. Deshabilite la restricción sin borrarla
ALTER TABLE RADIO
DISABLE CONSTRAINT UQ_WEB;

--2.4.2.Cambie la web de RNE1 y RNE3 a 'https://www.rtve.es' y compruebe que se ha modificado correctamente.
UPDATE RADIO
SET web='https://www.rtve.es'
WHERE nombre IN ('RNE1','RNE3');

SELECT * FROM RADIO WHERE nombre IN('RNE1','RNE3');

--2.5. Modifique el esquema para añadir un nuevo campo obligatorio Fecha_Fundacion de tipo DATE que almacene la fecha de fundación de las radios. Compruebe si es posible. En caso negativo, resuélvalo indicando en la modificación del esquema el valor por defecto SYSDATE para el nuevo campo.
ALTER TABLE RADIO
ADD Fecha_Fundacion DATE DEFAULT SYSDATE NOT NULL;

DESC RADIO;

--2.6 Añada una restricción que permita que el teléfono de las radios pueda ser desconocido.
ALTER TABLE RADIO--permitir telefonos desconocidos
MODIFY telefono VARCHAR(20) DEFAULT 'Desconocido';

ALTER TABLE RADIO
ADD CONSTRAINT CHK_TELEFONO--obligue a que sea desconocido o sea un número de teléfono de 9 dígitos
CHECK(telefono='Desconocido' OR LENGTH(telefono)=9);

--PARTE 3
--3.Resuleva las siguientes consultas y vistas:

--3.1 Nombre de los grupos españoles
SELECT nombre
FROM GRUPO
WHERE pais='Espanya';

--3.2 Nombre y web de las emisoras de radio cuya web tenga dominio en España(por ejemplo, que contenga la cadena ".es/" o bien termine en ".es")
SELECT nombre, web
FROM RADIO
WHERE web LIKE '%.es/%' OR web LIKE '%.es%';

--3.3 Nombre de los grupos y número copias totales vendidas, ordenados de mayor a menor por el número de copias vendidas
SELECT G.nombre,SUM(V.copiasVendidas)
FROM GRUPO G
JOIN VINILO V ON G.nombre=V.grupo
GROUP BY G.nombre
ORDER BY SUM(V.copiasVendidas) DESC;

--3.4 Nombre de los autores(sin repetir) de los temas que se encuentran en sencillos
SELECT DISTINCT T.autor
FROM TEMA T
WHERE T.sencillo IS NOT NULL;

---3.5 Para los LPs con sencillo editados, ISVN del LP y número de sencillos editados
SELECT LP.ISVN,COUNT(T.sencillo)
FROM LP
JOIN TEMA T ON LP.ISVN=T.LP
WHERE T.sencillo IS NOT NULL
GROUP BY LP.ISVN;

---3.6 Titulo de los Lps junto con el titulo, autor y duracion de sus temas

SELECT LP.titulo, T.titulo, T.autor, T.duracion
FROM LP
JOIN TEMA T ON LP.ISVN=T.LP;

--3.7 Titulo y grupo de los LPs que superen en ventas las copias de lanzamiento
SELECT LP.titulo,V.grupo
FROM LP
JOIN VINILO V ON LP.ISVN=V.ISVN
WHERE V.copiasVendidas>LP.copiasLanzamiento;

--3.8 Titulo de temas que no se han pinchado nunca en la radio
SELECT T.titulo
FROM TEMA T
WHERE NOT EXISTS(
    SELECT titulo
    FROM EMISION E
    WHERE E.tema=T.codigo);


--3.9 ISVN y titulos de LPs de grupos españoles
SELECT LP.ISVN, LP.titulo
FROM LP
JOIN VINILO V ON LP.ISVN=V.ISVN
JOIN GRUPO G ON V.grupo=G.nombre
WHERE G.pais='Espanya';

--3.10 ISVN y duracion total de los sencillos cuya duracion total sea superior a los 500 segundos

SELECT S.ISVN,SUM(T.duracion)
FROM SENCILLO S
JOIN TEMA T ON S.ISVN=T.sencillo
GROUP BY S.ISVN
HAVING SUM(T.duracion)>500;

---3.11 ISVN del sencillo, titulo del Lp al que pertenece, número de semanas en primer lugar del ranking durante el año 1989
SELECT R.primero,Lp.titulo,COUNT(*) AS "Número de semanas en primer lugar"
FROM RANKING R
JOIN SENCILLO S ON R.primero=S.ISVN
JOIN TEMA T ON S.ISVN=T.sencillo
JOIN LP ON T.LP=LP.ISVN
WHERE R.anyo=1989
GROUP BY R.primero,LP.titulo;

--3.12 Nombre y nacionalidad de grupos alguno de cuyos vinilos estan producidos por discograficas de su misma nacionalidad
SELECT DISTINCT G.nombre, G.pais
FROM GRUPO G
JOIN VINILO V ON G.nombre=V.grupo
JOIN DISCOGRAFICA D ON V.discografica=D.nombre AND G.pais=D.pais;

--3.13 Grupo que más veces se ha emitido en las radios y numero total de emisiones
SELECT G.nombre, COUNT(E.radio) AS "Número total de emisiones"
FROM GRUPO G
JOIN VINILO V ON G.nombre=V.grupo
JOIN TEMA T ON V.ISVN=T.LP
JOIN EMISION E ON T.codigo=E.tema
GROUP BY G.nombre
ORDER BY COUNT(E.radio) DESC
FETCH FIRST 1 ROWS ONLY;

--OTRA FORMA

SELECT G.nombre, COUNT(E.radio) AS "Número total de emisiones"
FROM GRUPO G
JOIN VINILO V ON G.nombre = V.grupo
JOIN TEMA T ON V.ISVN = T.LP
JOIN EMISION E ON T.codigo = E.tema
GROUP BY G.nombre
HAVING COUNT(E.radio) = (
    SELECT MAX(NumEmisiones)
    FROM (
        SELECT COUNT(E.radio) AS NumEmisiones
        FROM GRUPO G
        JOIN VINILO V ON G.nombre = V.grupo
        JOIN TEMA T ON V.ISVN = T.LP
        JOIN EMISION E ON T.codigo = E.tema
        GROUP BY G.nombre
    )
);

--3.14 Vista que contenga el nombre y el año de la fundación de los grupos

CREATE VIEW VistaGrupos AS
SELECT nombre, anyoFundacion
FROM GRUPO;

SELECT * FROM VistaGrupos;

INSERT INTO VistaGrupos VALUES('Nuevo grupo',2022);
SELECT * FROM GRUPO;

--3.15 Vista que contenga el nombre y la direccion de las radios

CREATE VIEW VistaRadio AS
SELECT nombre, direccion
FROM RADIO;
SELECT * FROM VistaRadio;--como web no puede ser null se debe añadir algo
INSERT INTO VistaRadio VALUES('NuevaRadio', 'NuevaDireccion','https://www.ejemplo.es');--da error porque estamos intentando introducir mas valores que los establecidos en la vista
SELECT * FROM RADIO;

--3.16 Vista que contenga el nombre del grupo y numero de vinilos publicados por dicho grupo. El atributo que contenga el numero de vinilos debera llamarse TotalVinilos

CREATE VIEW vistaVinilosPorGrupos AS
SELECT G.nombre, COUNT(ISVN) AS "TotalVinilos"
FROM GRUPO G
LEFT JOIN VINILO V ON G.nombre=V.grupo
GROUP BY G.nombre;

SELECT * FROM vistaVinilosPorGrupos;
INSERT INTO vistaVinilosPorGrupos VALUES('NuevoGrupo',5);-- da error 


--PARTE 4 :Actualización de datos y modificación del esquema.

--4.1. Intente borrar las siguientes tuplas. En los casos en los que se pueda llevar a cabo el borrado, compruebe qué consecuencias ha tenido dicho borrado en otras tablas. En los casos en los que el borrado sea rechazado por Oracle, piense en los motivos y en formas alternativas de realizar el borrado.

--4.1.1.Vinilo 6000000001 de Rosalía.

DELETE FROM VINILO
WHERE ISVN=6000000001 AND grupo='Rosalia';

--Da error el borrado debido al borrado restringuido que hay en la clave ajena de LP en TEMA y la clave ajena de SENCILLO en TEMA
--Se podría arreglar cambiando esas dos retricciones a borrado en cascada o borrando del TEMA directamente los de Rosalía y después borrar el VINILO
DELETE FROM EMISION
WHERE(tema) IN(
            SELECT codigo
            FROM TEMA
            WHERE LP=6000000001 AND Autor='Rosalia');            

DELETE FROM TEMA 
WHERE LP=6000000001 AND Autor='Rosalia';

DELETE FROM VINILO--Y AHORA YA TE DEJA BORRAR EL VINILO
WHERE ISVN=6000000001 AND grupo='Rosalia';


--4.1.2.Radio RNE3.
DELETE FROM RADIO
WHERE nombre='RNE3';

--4.1.3.Discográfica RCA.
DELETE FROM DISCOGRAFICA
WHERE nombre='RCA';

--4.2. Incremente en dos minutos el valor del atributo 'fechaHora' de las emisiones de radio del 01/04/1981.
UPDATE EMISION
SET fechaHora=fechaHora+2
WHERE fechaHora=' 01/04/1981';

--4.3. Duplique el número de copias de lanzamiento para los LPs del grupo Queen.
UPDATE LP 
SET copiaslanzamiento=copiaslanzamiento*2
WHERE(copiaslanzamiento) IN(
                            SELECT copiaslanzamiento
                            FROM LP,VINILO V
                            WHERE V.grupo='Queen');
                            
    
--Modifique el grafo o esquema relacional para considerar los siguientes supuestos:

--4.4. En la actualidad solo se almacena el nombre del grupo en la base de datos. Añada una tabla con la información de los miembros del grupo que lo componen (Identificador, nombre, fecha de nacimiento, país de nacimiento) y asocie cada miembro al grupo al que pertenece, asumiendo que pertenece a un único grupo. 
CREATE TABLE MUSICO(
Identificador VARCHAR(120) PRIMARY KEY,
nombre VARCHAR(120) NOT NULL,
fechaNacimiento DATE NOT NULL,
pais VARCHAR(120)NOT NULL,
grupo VARCHAR(120) UNIQUE NOT NULL
);
ALTER TABLE MUSICO 
    ADD CONSTRAINTS M_G FOREIGN KEY(grupo) REFERENCES GRUPO ON DELETE SET NULL;

--Piense en una solución alternativa si los grupos van cambiando de composición, es decir, incorporándose unos miembros y desvinculándose otros a lo largo del tiempo.

CREATE TABLE MUSICO(
Identificador VARCHAR(120) PRIMARY KEY,
nombre VARCHAR(120) NOT NULL,
fechaNacimiento DATE NOT NULL,
pais VARCHAR(120)NOT NULL,
grupo VARCHAR(120) UNIQUE NOT NULL
);
ALTER TABLE MUSICO 
    ADD CONSTRAINTS M_G FOREIGN KEY(grupo) REFERENCES GRUPO ON DELETE SET NULL ON UPDATE CASCADE;--meterle que si se modifican los también se cambie en los musicos
    
--4.5. En la solución actual únicamente se guardan los tres primeros puestos del ranking semanal. ¿Cómo modificaría el esquema para incorporar cualquier número de puestos? ¿Su solución recoge que haya al menos un primer puesto todas las semanas?
--lo que ya había 
CREATE TABLE RANKING(
    anyo NUMBER(4),
    semana NUMBER(2),
    primero NUMBER(10) NOT NULL,
    segundo NUMBER(10) NOT NULL,
    tercero NUMBER(10) NOT NULL,
    PRIMARY KEY(anyo,semana)  
);
ALTER TABLE RANKING 
    ADD CONSTRAINT RAN_SEN1 FOREIGN KEY(primero) REFERENCES SENCILLO ON DELETE CASCADE;--CLAVE AJENA A SENCILLO B:C M:R
ALTER TABLE RANKING 
    ADD CONSTRAINT RAN_SEN2 FOREIGN KEY(segundo) REFERENCES SENCILLO ON DELETE CASCADE;--CLAVE AJENA A SENCILLO B:C M:R
ALTER TABLE RANKING 
    ADD CONSTRAINT RAN_SEN3 FOREIGN KEY(tercero) REFERENCES SENCILLO ON DELETE CASCADE;--CLAVE AJENA A SENCILLO B:C M:R 
    
--modificaciones para lograr lo que pide
ALTER TABLE RANKING DROP(primero,segundo,tercero);--BORRAR LOS ATRIBUTOS 

--DROP TABLE PUESTOSRANKING;
CREATE TABLE PUESTOSRANKING(
puesto NUMBER(10),
sencillo NUMBER(10),
PRIMARY KEY(sencillo)--porque el ranking depende de sencillo
);
ALTER TABLE PUESTOSRANKING--DEPENDE DE SENCILLO COMO ERA EL CASO DE PRIMERO SEGUNDO Y TERCERO
    ADD CONSTRAINTS Sen_Sen FOREIGN KEY(sencillo) REFERENCES SENCILLO ON DELETE CASCADE;
    
ALTER TABLE RANKING 
    ADD puesto NUMBER (10);
    
DESC RANKING;--comprobar que se ha añadido el atributo de puesto a la tabla de ranking
    
ALTER TABLE RANKING 
    ADD CONSTRAINTS Pues_Pues FOREIGN KEY(puesto) REFERENCES PUESTOSRANKING ON DELETE CASCADE;
    
--4.6. La base de datos actual cada vinilo se corresponde con un único grupo. ¿Cómo modificaría el esquema para permitir que existieran vinilos en los que participaran varios grupos?
--lo que ya hay creado 
CREATE TABLE VINILO(
    ISVN NUMBER(10) PRIMARY KEY,
    fechaLanzamiento DATE NOT NULL,
    copiasVendidas NUMBER(8) NOT NULL,
    grupo VARCHAR2(120) NOT NULL, 
    discografica VARCHAR2(120)
);
ALTER TABLE VINILO
    ADD CONSTRAINT VIN_GRUP FOREIGN KEY(grupo) REFERENCES GRUPO;--CLAVE AJENA A GRUPO B:R M:R
    
ALTER TABLE VINILO
    ADD CONSTRAINT VIN_DIS FOREIGN KEY(discografica) REFERENCES DISCOGRAFICA ON DELETE SET NULL;--CLAVE AJENA A DISCOGRAFICA B:N M:R
    
--modificaciones
ALTER TABLE VINILO DROP(grupo);--eliminar el atributo de grupo de la tabla de vinilo

CREATE TABLE COMPONENTESVINILO(--crear una nueva tabla donde se guarden a los grupos que pertenezcan a un vinilo(relacion N:M)
grupo VARCHAR2(120),
ISVN NUMBER(10),
PRIMARY KEY(grupo,ISVN)
);
ALTER TABLE COMPONENTESVINILO
    ADD CONSTRAINTS Grup_Grup FOREIGN KEY(grupo) REFERENCES GRUPO;
    
ALTER TABLE COMPONENTESVINILO  
    ADD CONSTRAINTS ISVN_Vin FOREIGN KEY (ISVN) REFERENCES VINILO;


--4.7. El diseño actual permite muchas inconsistencias en los datos. ¿Qué inconsistencia eliminaría las siguientes sentencias?:
ALTER TABLE SENCILLO ADD UNIQUE (ISVN, ISVNLP);
--La primera sentencia establece una restricción de unicidad en esas columnas, lo que significa que no puedes tener dos filas en la tabla SENCILLO con los mismos valores de ISVN e ISVNLP, eliminando la posibilidad de duplicados en SENCILLO


ALTER TABLE TEMA ADD FOREIGN KEY (sencillo, LP)
 REFERENCES SENCILLO (ISVN,ISVNLP);
--La segunda sentencia establece una relación de clave ajena desde la tabla TEMA a la tabla SENCILLO utilizando esas columnas como referencia (sencillo y LP).
Introduciendo una dependencia en la relación entre TEMA y SENCILLO. Esto significa que un registro en TEMA que hace referencia a un registro específico en SENCILLO debe encontrar ese registro exacto con la combinación correspondiente de ISVN e ISVNLP.

---En términos generales, esta estructura implica que cada combinación de ISVN e ISVNLP en SENCILLO solo puede aparecer una vez en la tabla TEMA.
