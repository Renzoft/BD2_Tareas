-- ========================================
-- 3.4 TRIGGER: CONTROL DE INGRESO Y MARCA DE INASISTENCIA
-- ========================================

CREATE OR REPLACE TRIGGER trg_validar_ingreso
BEFORE INSERT ON asistencia_empleado
FOR EACH ROW
DECLARE
  v_hora_inicio horario.hora_inicio%TYPE;
  v_hora_fin horario.hora_fin%TYPE;
  v_turno VARCHAR2(20);
  v_dia VARCHAR2(15);
BEGIN
  -- Obtener día y turno correspondiente al empleado
  SELECT h.hora_inicio, h.hora_fin, h.turno, h.dia_semana
  INTO v_hora_inicio, v_hora_fin, v_turno, v_dia
  FROM horario h
  JOIN empleado_horario eh 
    ON h.dia_semana = eh.dia_semana AND h.turno = eh.turno
  WHERE eh.employee_id = :NEW.employee_id
    AND eh.dia_semana = :NEW.dia_semana;

  -- Verificar tolerancia de media hora antes o después (± 30 minutos)
  IF :NEW.hora_inicio_real < (v_hora_inicio - (30/1440))
     OR :NEW.hora_inicio_real > (v_hora_inicio + (30/1440)) THEN

    -- Marcamos inasistencia silenciosa
    :NEW.hora_inicio_real := NULL;
    :NEW.hora_fin_real := NULL;

    -- Registrar en consola (solo el administrador lo ve)
    DBMS_OUTPUT.PUT_LINE('Aviso: Empleado ID ' || :NEW.employee_id ||
                         ' llegó fuera del rango permitido y fue marcado como inasistente.');
  END IF;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No existe horario asignado para el empleado ID ' || :NEW.employee_id ||
                         ' en el día ' || :NEW.dia_semana);
END;
/

-- Prueba de funcionamiento
ALTER TRIGGER trg_validar_asistencia DISABLE;
INSERT INTO asistencia_empleado 
VALUES (1, 'Lunes', TO_DATE('2024-10-21', 'YYYY-MM-DD'),
        TO_DATE('07:45', 'HH24:MI'), TO_DATE('16:00', 'HH24:MI'));

-- Verificando
SELECT * FROM asistencia_empleado;