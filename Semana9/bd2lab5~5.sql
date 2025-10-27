-- ========================================
-- 3.2 TRIGGER: VALIDAR INSERCIÓN DE ASISTENCIA
-- ========================================

CREATE OR REPLACE TRIGGER trg_validar_asistencia
BEFORE INSERT ON asistencia_empleado
FOR EACH ROW
DECLARE
  v_dia_semana VARCHAR2(15);
  v_hora_inicio DATE;
  v_hora_fin DATE;
  v_turno VARCHAR2(20);
BEGIN
  -- 1️⃣ Validar que el día de la semana coincida con la fecha_real
  v_dia_semana := INITCAP(TO_CHAR(:NEW.fecha_real, 'DAY', 'NLS_DATE_LANGUAGE=SPANISH'));
  v_dia_semana := RTRIM(v_dia_semana); -- Elimina espacios
  IF UPPER(v_dia_semana) <> UPPER(:NEW.dia_semana) THEN
    RAISE_APPLICATION_ERROR(-20001, 'Error: El día de la semana no corresponde con la fecha ingresada.');
  END IF;

  -- 2️⃣ Obtener el horario del empleado para ese día
  SELECT h.hora_inicio, h.hora_fin, h.turno
  INTO v_hora_inicio, v_hora_fin, v_turno
  FROM horario h
  JOIN empleado_horario eh
    ON h.dia_semana = eh.dia_semana AND h.turno = eh.turno
  WHERE eh.employee_id = :NEW.employee_id
    AND UPPER(h.dia_semana) = UPPER(:NEW.dia_semana);

  -- 3️⃣ Validar hora de inicio real ≈ hora programada
  IF ABS((:NEW.hora_inicio_real - v_hora_inicio) * 24 * 60) > 15 THEN
    RAISE_APPLICATION_ERROR(-20002, 'Error: Hora de inicio real no corresponde al horario asignado.');
  END IF;

  -- 4️⃣ Validar hora de fin real ≈ hora programada
  IF ABS((:NEW.hora_fin_real - v_hora_fin) * 24 * 60) > 15 THEN
    RAISE_APPLICATION_ERROR(-20003, 'Error: Hora de término real no corresponde al horario asignado.');
  END IF;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20004, 'Error: No existe un horario asignado para este empleado en ese día.');
END;
/

-- Pruebas de inserción
INSERT INTO asistencia_empleado
VALUES (1, 'Lunes', TO_DATE('2024-10-07', 'YYYY-MM-DD'), TO_DATE('08:02', 'HH24:MI'), TO_DATE('16:05', 'HH24:MI'));