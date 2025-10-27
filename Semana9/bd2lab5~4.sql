-- ========================================
-- Ejercicio 3.1.2.
-- ========================================
-- ========================================
-- 3.1.2 PROCEDIMIENTO: LISTAR CAPACITACIONES Y HORAS POR EMPLEADO
-- ========================================

CREATE OR REPLACE PACKAGE capacitacion_pkg AS
  PROCEDURE listar_capacitaciones_empleado;
END capacitacion_pkg;
/

CREATE OR REPLACE PACKAGE BODY capacitacion_pkg AS

  PROCEDURE listar_capacitaciones_empleado IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('NOMBRE EMPLEADO | APELLIDO | TOTAL HORAS | CAPACITACIONES');
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------');

    FOR r IN (
      SELECT 
        e.nombre,
        e.apellido,
        SUM(c.horas) AS total_horas,
        LISTAGG(c.nombre, ', ') WITHIN GROUP (ORDER BY c.nombre) AS lista_capacitaciones
      FROM employee e
      JOIN empleado_capacitacion ec ON e.employee_id = ec.employee_id
      JOIN capacitacion c ON ec.capacitacion_id = c.capacitacion_id
      GROUP BY e.nombre, e.apellido
      ORDER BY total_horas DESC
    ) LOOP
      DBMS_OUTPUT.PUT_LINE(
        RPAD(r.nombre, 12) || ' | ' ||
        RPAD(r.apellido, 12) || ' | ' ||
        LPAD(r.total_horas, 5) || ' | ' ||
        r.lista_capacitaciones
      );
    END LOOP;
  END listar_capacitaciones_empleado;

END capacitacion_pkg;
/

SET SERVEROUTPUT ON;
EXEC capacitacion_pkg.listar_capacitaciones_empleado;