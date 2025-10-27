-- --------------------------------
-- Ejercicio 3.1.6.
-- --------------------------------
CREATE OR REPLACE PACKAGE employee_pkg AS
  PROCEDURE top_empleados_rotacion;
  FUNCTION promedio_contrataciones RETURN NUMBER;
  PROCEDURE estadistica_regional;
  FUNCTION tiempo_servicio RETURN NUMBER;
  FUNCTION horas_trabajadas(p_employee_id NUMBER, p_mes NUMBER, p_anio NUMBER) RETURN NUMBER;
  FUNCTION horas_faltadas(p_employee_id NUMBER, p_mes NUMBER, p_anio NUMBER) RETURN NUMBER;
END employee_pkg;
/
CREATE OR REPLACE PACKAGE BODY employee_pkg AS

  -- 3.1.1
  PROCEDURE top_empleados_rotacion IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('CÓDIGO | APELLIDO | NOMBRE | PUESTO ACTUAL | ROTACIONES');
    FOR r IN (
      SELECT e.employee_id, e.apellido, e.nombre, p.nombre AS puesto, COUNT(h.historial_id) AS cambios
      FROM employee e
      JOIN puesto p ON e.puesto_id = p.puesto_id
      JOIN historial_puestos h ON e.employee_id = h.employee_id
      GROUP BY e.employee_id, e.apellido, e.nombre, p.nombre
      ORDER BY cambios DESC FETCH FIRST 4 ROWS ONLY
    ) LOOP
      DBMS_OUTPUT.PUT_LINE(r.employee_id || ' | ' || r.apellido || ' | ' || r.nombre || ' | ' || r.puesto || ' | ' || r.cambios);
    END LOOP;
  END;

  -- 3.1.2
  FUNCTION promedio_contrataciones RETURN NUMBER IS
    v_total NUMBER := 0;
  BEGIN
    FOR r IN (
      SELECT TO_CHAR(fecha_ingreso, 'Month', 'NLS_DATE_LANGUAGE=SPANISH') AS mes,
             ROUND(COUNT(*) / COUNT(DISTINCT EXTRACT(YEAR FROM fecha_ingreso)), 2) AS promedio
      FROM employee
      GROUP BY TO_CHAR(fecha_ingreso, 'Month', 'NLS_DATE_LANGUAGE=SPANISH'),
               TO_NUMBER(TO_CHAR(fecha_ingreso, 'MM'))
      ORDER BY TO_NUMBER(TO_CHAR(fecha_ingreso, 'MM'))
    ) LOOP
      DBMS_OUTPUT.PUT_LINE(RTRIM(r.mes) || ' | ' || r.promedio);
      v_total := v_total + 1;
    END LOOP;
    RETURN v_total;
  END;

  -- 3.1.3
  PROCEDURE estadistica_regional IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('REGIÓN | TOTAL SALARIOS | EMPLEADOS | MÁS ANTIGUO');
    FOR r IN (
      SELECT reg.nombre AS region,
             SUM(emp.salario) AS total_salario,
             COUNT(emp.employee_id) AS empleados,
             MIN(emp.fecha_ingreso) AS antiguo
      FROM employee emp
      JOIN region reg ON emp.region_id = reg.region_id
      GROUP BY reg.nombre
    ) LOOP
      DBMS_OUTPUT.PUT_LINE(r.region || ' | ' || r.total_salario || ' | ' || r.empleados || ' | ' || TO_CHAR(r.antiguo, 'DD-MON-YYYY'));
    END LOOP;
  END;

  -- 3.1.4
  FUNCTION tiempo_servicio RETURN NUMBER IS
    v_total NUMBER := 0;
    v_meses NUMBER;
  BEGIN
    FOR r IN (
      SELECT employee_id, nombre, apellido, TRUNC(MONTHS_BETWEEN(SYSDATE, fecha_ingreso)/12) AS anios
      FROM employee
    ) LOOP
      v_meses := r.anios;
      DBMS_OUTPUT.PUT_LINE(r.nombre || ' ' || r.apellido || ' | ' || r.anios || ' años | ' || v_meses || ' meses');
      v_total := v_total + v_meses;
    END LOOP;
    RETURN v_total;
  END;

  -- 3.1.5
  FUNCTION horas_trabajadas(p_employee_id NUMBER, p_mes NUMBER, p_anio NUMBER) RETURN NUMBER IS
    v_total_horas NUMBER := 0;
  BEGIN
    DBMS_OUTPUT.PUT_LINE('FECHA | HORAS TRABAJADAS');
    FOR r IN (
      SELECT fecha_real,
             ROUND((hora_fin_real - hora_inicio_real) * 24, 2) AS horas
      FROM asistencia_empleado
      WHERE employee_id = p_employee_id
        AND EXTRACT(MONTH FROM fecha_real) = p_mes
        AND EXTRACT(YEAR FROM fecha_real) = p_anio
    ) LOOP
      DBMS_OUTPUT.PUT_LINE(TO_CHAR(r.fecha_real, 'DD-MON-YYYY') || ' | ' || r.horas);
      v_total_horas := v_total_horas + r.horas;
    END LOOP;
    RETURN v_total_horas;
  END;

  -- 3.1.6
  FUNCTION horas_faltadas(p_employee_id NUMBER, p_mes NUMBER, p_anio NUMBER) RETURN NUMBER IS
    v_horas_programadas NUMBER := 0;
    v_horas_trabajadas  NUMBER := 0;
    v_horas_faltadas    NUMBER := 0;
  BEGIN
    -- Total de horas programadas según horario
    SELECT SUM((h.hora_fin - h.hora_inicio) * 24)
    INTO v_horas_programadas
    FROM horario h
    JOIN empleado_horario eh ON h.dia_semana = eh.dia_semana AND h.turno = eh.turno
    WHERE eh.employee_id = p_employee_id;

    -- Total de horas efectivamente trabajadas (usando la función anterior)
    v_horas_trabajadas := horas_trabajadas(p_employee_id, p_mes, p_anio);

    -- Diferencia
    v_horas_faltadas := v_horas_programadas - v_horas_trabajadas;

    DBMS_OUTPUT.PUT_LINE('Horas programadas: ' || v_horas_programadas);
    DBMS_OUTPUT.PUT_LINE('Horas trabajadas:  ' || v_horas_trabajadas);
    DBMS_OUTPUT.PUT_LINE('Horas faltadas:    ' || v_horas_faltadas);

    RETURN v_horas_faltadas;
  END;

END employee_pkg;
/
SET SERVEROUTPUT ON;
VAR v_faltas NUMBER;
EXEC :v_faltas := employee_pkg.horas_faltadas(1, 10, 2024);
PRINT v_faltas;
