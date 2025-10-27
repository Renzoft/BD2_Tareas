-- ===============================================
-- LABORATORIO DE TRANSACCIONES - EJERCICIO 1
-- CONTROL BÁSICO DE TRANSACCIONES
-- ===============================================

SET SERVEROUTPUT ON;

DECLARE
  v_contador90 NUMBER;
  v_contador60 NUMBER;
BEGIN
  -- Aumento del 10% al salario de los empleados del departamento 90
  UPDATE employees
  SET salary = salary * 1.10
  WHERE department_id = 90;

  SELECT COUNT(*) INTO v_contador90 FROM employees WHERE department_id = 90;
  DBMS_OUTPUT.PUT_LINE('Aumentado salario en 10% para ' || v_contador90 || ' empleados del depto 90.');

  -- SAVEPOINT PUNTO1
  SAVEPOINT punto1;
  DBMS_OUTPUT.PUT_LINE('SAVEPOINT punto1 establecido.');

  -- Aumento del 5% al salario de los empleados del departamento 60
  UPDATE employees
  SET salary = salary * 1.05
  WHERE department_id = 60;

  SELECT COUNT(*) INTO v_contador60 FROM employees WHERE department_id = 60;
  DBMS_OUTPUT.PUT_LINE('Aumentado salario en 5% para ' || v_contador60 || ' empleados del depto 60.');

  -- ROLLBACK AL SAVEPOINT PUNTO1
  ROLLBACK TO punto1;
  DBMS_OUTPUT.PUT_LINE('Rollback al SAVEPOINT punto1 ejecutado. Se deshacen cambios del depto 60.');

  -- CONFIRMAR TRANSACCIÓN FINAL
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Transacción confirmada (COMMIT ejecutado).');
END;
/

SELECT employee_id, first_name, salary, department_id
FROM employees
WHERE department_id IN (60, 90);