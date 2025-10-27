-- --------------------------------
-- Ejercicio 3.1.7.
-- --------------------------------
CREATE OR REPLACE PACKAGE employee_pkg AS
  PROCEDURE top_empleados_rotacion;
  FUNCTION promedio_contrataciones RETURN NUMBER;
  PROCEDURE estadistica_regional;
  FUNCTION tiempo_servicio RETURN NUMBER;
  FUNCTION horas_trabajadas(p_employee_id NUMBER, p_mes NUMBER, p_anio NUMBER) RETURN NUMBER;
  FUNCTION horas_faltadas(p_employee_id NUMBER, p_mes NUMBER, p_anio NUMBER) RETURN NUMBER;
  PROCEDURE calcular_sueldo(p_mes NUMBER, p_anio NUMBER);
END employee_pkg;
/
CREATE OR REPLACE PACKAGE BODY employee_pkg AS

  -- 3.1.1
  PROCEDURE top_empleados_rotacion IS
  BEGIN
    NULL;
  END;

  -- 3.1.2
  FUNCTION promedio_contrataciones RETURN NUMBER IS
  BEGIN
    RETURN 0;
  END;

  -- 3.1.3
  PROCEDURE estadistica_regional IS
  BEGIN
    NULL;
  END;

  -- 3.1.4
  FUNCTION tiempo_servicio RETURN NUMBER IS
  BEGIN
    RETURN 0;
  END;

  -- 3.1.5
  FUNCTION horas_trabajadas(p_employee_id NUMBER, p_mes NUMBER, p_anio NUMBER) RETURN NUMBER IS
    v_total_horas NUMBER := 0;
  BEGIN
    FOR r IN (
      SELECT fecha_real,
             ROUND((hora_fin_real - hora_inicio_real) * 24, 2) AS horas
      FROM asistencia_empleado
      WHERE employee_id = p_employee_id
        AND EXTRACT(MONTH FROM fecha_real) = p_mes
        AND EXTRACT(YEAR FROM fecha_real) = p_anio
    ) LOOP
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
    SELECT SUM((h.hora_fin - h.hora_inicio) * 24)
    INTO v_horas_programadas
    FROM horario h
    JOIN empleado_horario eh ON h.dia_semana = eh.dia_semana AND h.turno = eh.turno
    WHERE eh.employee_id = p_employee_id;

    v_horas_trabajadas := horas_trabajadas(p_employee_id, p_mes, p_anio);
    v_horas_faltadas := v_horas_programadas - v_horas_trabajadas;

    RETURN v_horas_faltadas;
  END;

  -- 3.1.7
  PROCEDURE calcular_sueldo(p_mes NUMBER, p_anio NUMBER) IS
    v_horas_programadas NUMBER;
    v_horas_trabajadas  NUMBER;
    v_sueldo_proporcional NUMBER;
  BEGIN
    DBMS_OUTPUT.PUT_LINE('NOMBRE | APELLIDO | SUELDO MENSUAL AJUSTADO');

    FOR r IN (SELECT employee_id, nombre, apellido, salario FROM employee) LOOP

      -- Total de horas programadas
      SELECT SUM((h.hora_fin - h.hora_inicio) * 24)
      INTO v_horas_programadas
      FROM horario h
      JOIN empleado_horario eh ON h.dia_semana = eh.dia_semana AND h.turno = eh.turno
      WHERE eh.employee_id = r.employee_id;

      -- Total de horas trabajadas
      v_horas_trabajadas := horas_trabajadas(r.employee_id, p_mes, p_anio);

      -- Cálculo proporcional del sueldo
      IF v_horas_programadas > 0 THEN
        v_sueldo_proporcional := (v_horas_trabajadas / v_horas_programadas) * r.salario;
      ELSE
        v_sueldo_proporcional := 0;
      END IF;

      DBMS_OUTPUT.PUT_LINE(
        RPAD(r.nombre, 10) || ' | ' ||
        RPAD(r.apellido, 10) || ' | ' ||
        LPAD(TO_CHAR(v_sueldo_proporcional, '9999.99'), 10)
      );

    END LOOP;
  END;

END employee_pkg;
/
SET SERVEROUTPUT ON;
EXEC employee_pkg.calcular_sueldo(10, 2024);
