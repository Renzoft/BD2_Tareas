ALTER TABLE puesto ADD (salario_min NUMBER(10,2), salario_max NUMBER(10,2));

-- Actualizamos los rangos de ejemplo
UPDATE puesto SET salario_min = 3000, salario_max = 4000 WHERE nombre = 'Analista';
UPDATE puesto SET salario_min = 4000, salario_max = 5000 WHERE nombre = 'Programador';
UPDATE puesto SET salario_min = 5500, salario_max = 6500 WHERE nombre = 'Jefe de Proyecto';
UPDATE puesto SET salario_min = 8000, salario_max = 9000 WHERE nombre = 'Gerente';

COMMIT;

-- ========================================
-- 3.3 TRIGGER: VALIDAR RANGO DE SALARIO
-- ========================================

CREATE OR REPLACE TRIGGER trg_validar_salario
BEFORE INSERT OR UPDATE OF salario, puesto_id ON employee
FOR EACH ROW
DECLARE
  v_min NUMBER;
  v_max NUMBER;
  v_nombre_puesto VARCHAR2(50);
BEGIN
  -- Obtener los rangos del puesto correspondiente
  SELECT salario_min, salario_max, nombre
  INTO v_min, v_max, v_nombre_puesto
  FROM puesto
  WHERE puesto_id = :NEW.puesto_id;

  -- Validar que el salario esté dentro del rango
  IF :NEW.salario < v_min OR :NEW.salario > v_max THEN
    RAISE_APPLICATION_ERROR(
      -20010,
      'Error: El salario (' || :NEW.salario || 
      ') no está dentro del rango permitido para el puesto "' ||
      v_nombre_puesto || '" (' || v_min || ' - ' || v_max || ').'
    );
  END IF;
END;
/

-- Pruebas de inserción
INSERT INTO employee (nombre, apellido, fecha_ingreso, puesto_id, region_id, salario)
VALUES ('José', 'Ramírez', SYSDATE, 2, 1, 4500);  -- Programador (rango 4000–5000)
-- Pruebas de actualización
UPDATE employee SET salario = 4100 WHERE employee_id = 1;