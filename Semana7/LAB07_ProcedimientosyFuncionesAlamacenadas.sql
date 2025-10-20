-- ========================================
-- LABORATORIO SQL DDL - CREACIÓN DE TABLAS
-- ========================================

CREATE TABLE S (
  S# VARCHAR2(5) PRIMARY KEY,
  SNAME VARCHAR2(30),
  STATUS NUMBER,
  CITY VARCHAR2(20)
);

INSERT INTO S VALUES ('S1', 'Smith', 20, 'London');
INSERT INTO S VALUES ('S2', 'Jones', 10, 'Paris');
INSERT INTO S VALUES ('S3', 'Blake', 30, 'Paris');
INSERT INTO S VALUES ('S4', 'Clark', 20, 'London');
INSERT INTO S VALUES ('S5', 'Adams', 30, 'Athens');
COMMIT;

CREATE TABLE P (
  P# VARCHAR2(5) PRIMARY KEY,
  PNAME VARCHAR2(30),
  COLOR VARCHAR2(15),
  WEIGHT NUMBER,
  CITY VARCHAR2(20)
);

INSERT INTO P VALUES ('P1', 'Nut', 'Red', 12, 'London');
INSERT INTO P VALUES ('P2', 'Bolt', 'Green', 17, 'Paris');
INSERT INTO P VALUES ('P3', 'Screw', 'Blue', 17, 'Rome');
INSERT INTO P VALUES ('P4', 'Screw', 'Red', 14, 'London');
INSERT INTO P VALUES ('P5', 'Cam', 'Blue', 12, 'Paris');
INSERT INTO P VALUES ('P6', 'Cog', 'Red', 19, 'London');
COMMIT;

CREATE TABLE SP (
  S# VARCHAR2(5),
  P# VARCHAR2(5),
  QTY NUMBER,
  CONSTRAINT pk_sp PRIMARY KEY (S#, P#),
  CONSTRAINT fk_sp_s FOREIGN KEY (S#) REFERENCES S(S#),
  CONSTRAINT fk_sp_p FOREIGN KEY (P#) REFERENCES P(P#)
);

INSERT INTO SP VALUES ('S1', 'P1', 300);
INSERT INTO SP VALUES ('S1', 'P2', 200);
INSERT INTO SP VALUES ('S1', 'P3', 400);
INSERT INTO SP VALUES ('S1', 'P4', 200);
INSERT INTO SP VALUES ('S1', 'P5', 100);
INSERT INTO SP VALUES ('S1', 'P6', 100);
INSERT INTO SP VALUES ('S2', 'P1', 300);
INSERT INTO SP VALUES ('S2', 'P2', 400);
INSERT INTO SP VALUES ('S3', 'P2', 200);
INSERT INTO SP VALUES ('S4', 'P2', 200);
INSERT INTO SP VALUES ('S4', 'P4', 300);
INSERT INTO SP VALUES ('S4', 'P5', 400);
COMMIT;

CREATE TABLE J (
  J# VARCHAR2(5) PRIMARY KEY,
  JNAME VARCHAR2(30),
  CITY VARCHAR2(20)
);

INSERT INTO J VALUES ('J1', 'Sorter', 'Paris');
INSERT INTO J VALUES ('J2', 'Display', 'Rome');
INSERT INTO J VALUES ('J3', 'OCR', 'Athens');
INSERT INTO J VALUES ('J4', 'Console', 'Athens');
INSERT INTO J VALUES ('J5', 'RAID', 'London');
INSERT INTO J VALUES ('J6', 'EDS', 'Oslo');
INSERT INTO J VALUES ('J7', 'Tape', 'London');
COMMIT;

CREATE TABLE SPJ (
  S# VARCHAR2(5),
  P# VARCHAR2(5),
  J# VARCHAR2(5),
  QTY NUMBER,
  CONSTRAINT pk_spj PRIMARY KEY (S#, P#, J#),
  CONSTRAINT fk_spj_s FOREIGN KEY (S#) REFERENCES S(S#),
  CONSTRAINT fk_spj_p FOREIGN KEY (P#) REFERENCES P(P#),
  CONSTRAINT fk_spj_j FOREIGN KEY (J#) REFERENCES J(J#)
);

INSERT INTO SPJ VALUES ('S1', 'P1', 'J1', 200);
INSERT INTO SPJ VALUES ('S1', 'P1', 'J4', 700);
INSERT INTO SPJ VALUES ('S2', 'P3', 'J1', 400);
INSERT INTO SPJ VALUES ('S2', 'P3', 'J2', 200);
INSERT INTO SPJ VALUES ('S2', 'P3', 'J3', 200);
INSERT INTO SPJ VALUES ('S2', 'P3', 'J4', 500);
INSERT INTO SPJ VALUES ('S2', 'P3', 'J5', 600);
INSERT INTO SPJ VALUES ('S2', 'P3', 'J6', 400);
INSERT INTO SPJ VALUES ('S2', 'P3', 'J7', 800);
INSERT INTO SPJ VALUES ('S2', 'P5', 'J2', 100);
INSERT INTO SPJ VALUES ('S3', 'P3', 'J1', 200);
INSERT INTO SPJ VALUES ('S3', 'P4', 'J2', 500);
INSERT INTO SPJ VALUES ('S4', 'P6', 'J3', 300);
INSERT INTO SPJ VALUES ('S4', 'P6', 'J7', 300);
INSERT INTO SPJ VALUES ('S5', 'P2', 'J2', 200);
INSERT INTO SPJ VALUES ('S5', 'P2', 'J4', 100);
INSERT INTO SPJ VALUES ('S5', 'P5', 'J5', 500);
INSERT INTO SPJ VALUES ('S5', 'P5', 'J7', 100);
COMMIT;

SELECT * FROM S;
SELECT * FROM P;
SELECT * FROM SP;
SELECT * FROM J;
SELECT * FROM SPJ;

SET SERVEROUTPUT ON;

-- ========================================
-- LABORATORIO SQL DML - EJERCICIOS 4.1.1 AL 4.1.17
-- ========================================

-- ========================================
-- Ejercicio 4.1.1
-- ========================================

CREATE OR REPLACE PROCEDURE partes_no_paris AS
BEGIN
  FOR r IN (
    SELECT COLOR, CITY 
    FROM P 
    WHERE CITY <> 'Paris' 
      AND WEIGHT > 10
  ) LOOP
    DBMS_OUTPUT.PUT_LINE('Color: ' || r.COLOR || ' - Ciudad: ' || r.CITY);
  END LOOP;
END;
/

EXEC partes_no_paris;

-- ========================================
-- Ejercicio 4.1.2
-- ========================================

CREATE OR REPLACE FUNCTION peso_gramos(libras NUMBER)
RETURN NUMBER IS
BEGIN
  RETURN libras * 453.592;  -- Conversión de libras a gramos
END;
/

CREATE OR REPLACE PROCEDURE partes_en_gramos AS
BEGIN
  FOR r IN (SELECT P#, WEIGHT FROM P) LOOP
    DBMS_OUTPUT.PUT_LINE('Parte: ' || r.P# || 
                         ' -> ' || peso_gramos(r.WEIGHT) || ' gramos');
  END LOOP;
END;
/

EXEC partes_en_gramos;

-- ========================================
-- Ejercicio 4.1.3 
-- ========================================

CREATE OR REPLACE PROCEDURE mostrar_proveedores IS
BEGIN
  FOR r IN (SELECT S#, SNAME, STATUS, CITY FROM S) LOOP
    DBMS_OUTPUT.PUT_LINE('S#: ' || r.S# ||
                         ' | Nombre: ' || r.SNAME ||
                         ' | Status: ' || r.STATUS ||
                         ' | Ciudad: ' || r.CITY);
  END LOOP;
END;
/
EXEC mostrar_proveedores;

-- ========================================
-- Ejercicio 4.1.4
-- ========================================

CREATE OR REPLACE PROCEDURE mostrar_partes IS
BEGIN
  FOR r IN (SELECT P#, PNAME, COLOR, WEIGHT, CITY FROM P) LOOP
    DBMS_OUTPUT.PUT_LINE('P#: ' || r.P# ||
                         ' | Nombre: ' || r.PNAME ||
                         ' | Color: ' || r.COLOR ||
                         ' | Peso: ' || r.WEIGHT ||
                         ' | Ciudad: ' || r.CITY);
  END LOOP;
END;
/

EXEC mostrar_partes;

-- ========================================
-- Ejercicio 4.1.5
-- ========================================

CREATE OR REPLACE PROCEDURE pares_ciudades IS
BEGIN
  FOR r IN (
    SELECT DISTINCT s.city AS ciudad_proveedor, p.city AS ciudad_parte
    FROM s
    JOIN spj ON s.s# = spj.s#
    JOIN p   ON p.p# = spj.p#
  ) LOOP
    DBMS_OUTPUT.PUT_LINE('Proveedor en: ' || r.ciudad_proveedor ||
                         ' -> Parte en: ' || r.ciudad_parte);
  END LOOP;
END;
/

EXEC pares_ciudades;

-- ========================================
-- Ejercicio 4.1.6
-- ========================================

CREATE OR REPLACE PROCEDURE proveedores_colocalizados IS
BEGIN
  FOR r IN (
    SELECT s1.s# AS proveedor1, s2.s# AS proveedor2, s1.city
    FROM s s1
    JOIN s s2 ON s1.city = s2.city AND s1.s# < s2.s#
  ) LOOP
    DBMS_OUTPUT.PUT_LINE('Proveedor1: ' || r.proveedor1 ||
                         ' | Proveedor2: ' || r.proveedor2 ||
                         ' | Ciudad: ' || r.city);
  END LOOP;
END;
/

EXEC proveedores_colocalizados;

-- ========================================
-- Ejercicio 4.1.7
-- ========================================

CREATE OR REPLACE PROCEDURE total_proveedores IS
  v_total NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_total FROM S;
  DBMS_OUTPUT.PUT_LINE('Número total de proveedores: ' || v_total);
END;
/

EXEC total_proveedores;

-- ========================================
-- Ejercicio 4.1.8
-- ========================================

CREATE OR REPLACE PROCEDURE min_max_p2 IS
  v_min_qty NUMBER;
  v_max_qty NUMBER;
BEGIN
  SELECT MIN(QTY), MAX(QTY)
  INTO v_min_qty, v_max_qty
  FROM SPJ
  WHERE P# = 'P2';

  DBMS_OUTPUT.PUT_LINE('Parte P2 -> Cantidad mínima: ' || v_min_qty ||
                       ' | Cantidad máxima: ' || v_max_qty);
END;
/

EXEC min_max_p2;

-- ========================================
-- Ejercicio 4.1.9
-- ========================================

CREATE OR REPLACE PROCEDURE total_despachado_por_parte IS
BEGIN
  FOR r IN (
    SELECT P#, SUM(QTY) AS total_despachado
    FROM SPJ
    GROUP BY P#
  ) LOOP
    DBMS_OUTPUT.PUT_LINE('Parte: ' || r.P# ||
                         ' | Total despachado: ' || r.total_despachado);
  END LOOP;
END;
/

EXEC total_despachado_por_parte;

-- ========================================
-- Ejercicio 4.1.10
-- ========================================

CREATE OR REPLACE PROCEDURE partes_mas_de_un_proveedor IS
BEGIN
  FOR r IN (
    SELECT P#
    FROM SPJ
    GROUP BY P#
    HAVING COUNT(DISTINCT S#) > 1
  ) LOOP
    DBMS_OUTPUT.PUT_LINE('Parte abastecida por más de un proveedor: ' || r.P#);
  END LOOP;
END;
/

EXEC partes_mas_de_un_proveedor;

-- ========================================
-- Ejercicio 4.1.11
-- ========================================

CREATE OR REPLACE PROCEDURE proveedores_de_p2 IS
BEGIN
  FOR r IN (
    SELECT DISTINCT S.SNAME
    FROM S
    JOIN SPJ ON S.S# = SPJ.S#
    WHERE SPJ.P# = 'P2'
  ) LOOP
    DBMS_OUTPUT.PUT_LINE('Proveedor que abastece la parte P2: ' || r.SNAME);
  END LOOP;
END;
/

EXEC proveedores_de_p2;
-- ========================================
-- Ejercicio 4.1.11
-- ========================================

CREATE OR REPLACE PROCEDURE proveedores_de_p2 IS
BEGIN
  FOR r IN (
    SELECT DISTINCT S.SNAME
    FROM S
    JOIN SPJ ON S.S# = SPJ.S#
    WHERE SPJ.P# = 'P2'
  ) LOOP
    DBMS_OUTPUT.PUT_LINE('Proveedor que abastece la parte P2: ' || r.SNAME);
  END LOOP;
END;
/

EXEC proveedores_de_p2;

-- ========================================
-- Ejercicio 4.1.12
-- ========================================

CREATE OR REPLACE PROCEDURE proveedores_con_alguna_parte IS
BEGIN
  FOR r IN (
    SELECT DISTINCT S.SNAME
    FROM S
    WHERE S.S# IN (SELECT S# FROM SPJ)
  ) LOOP
    DBMS_OUTPUT.PUT_LINE('Proveedor con al menos una parte: ' || r.SNAME);
  END LOOP;
END;
/

EXEC proveedores_con_alguna_parte;

-- ========================================
-- Ejercicio 4.1.13
-- ========================================

CREATE OR REPLACE PROCEDURE proveedores_estado_menor_max IS
BEGIN
  FOR r IN (
    SELECT S#
    FROM S
    WHERE STATUS < (SELECT MAX(STATUS) FROM S)
  ) LOOP
    DBMS_OUTPUT.PUT_LINE('Proveedor con estado menor al máximo: ' || r.S#);
  END LOOP;
END;
/

EXEC proveedores_estado_menor_max;

-- ========================================
-- Ejercicio 4.1.14
-- ========================================

CREATE OR REPLACE PROCEDURE proveedores_de_p2_exists IS
BEGIN
  FOR r IN (
    SELECT SNAME
    FROM S
    WHERE EXISTS (
      SELECT 1
      FROM SPJ
      WHERE SPJ.S# = S.S#
      AND SPJ.P# = 'P2'
    )
  ) LOOP
    DBMS_OUTPUT.PUT_LINE('Proveedor que abastece la parte P2 (EXISTS): ' || r.SNAME);
  END LOOP;
END;
/

EXEC proveedores_de_p2_exists;

-- ========================================
-- Ejercicio 4.1.15
-- ========================================

CREATE OR REPLACE PROCEDURE proveedores_no_abastecen_p2 IS
BEGIN
  FOR r IN (
    SELECT SNAME
    FROM S
    WHERE S# NOT IN (
      SELECT S#
      FROM SPJ
      WHERE P# = 'P2'
    )
  ) LOOP
    DBMS_OUTPUT.PUT_LINE('Proveedor que NO abastece la parte P2: ' || r.SNAME);
  END LOOP;
END;
/

EXEC proveedores_no_abastecen_p2;

-- ========================================
-- Ejercicio 4.1.16
-- ========================================

CREATE OR REPLACE PROCEDURE proveedores_abastecen_todas_partes IS
BEGIN
  FOR r IN (
    SELECT SNAME
    FROM S
    WHERE NOT EXISTS (
      SELECT P#
      FROM P
      WHERE P# NOT IN (
        SELECT SPJ.P#
        FROM SPJ
        WHERE SPJ.S# = S.S#
      )
    )
  ) LOOP
    DBMS_OUTPUT.PUT_LINE('Proveedor que abastece todas las partes: ' || r.SNAME);
  END LOOP;
END;
/

EXEC proveedores_abastecen_todas_partes;

-- ========================================
-- Ejercicio 4.1.17
-- ========================================

CREATE OR REPLACE PROCEDURE partes_peso_o_proveedor IS
BEGIN
  FOR r IN (
    SELECT DISTINCT P#
    FROM P
    WHERE WEIGHT > 16
       OR P# IN (
            SELECT P#
            FROM SPJ
            WHERE S# = 'S2'
         )
  ) LOOP
    DBMS_OUTPUT.PUT_LINE('Parte que cumple condición: ' || r.P#);
  END LOOP;
END;
/

EXEC partes_peso_o_proveedor;