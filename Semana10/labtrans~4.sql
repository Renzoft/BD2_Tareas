-- ===============================================
-- LABORATORIO DE TRANSACCIONES - EJERCICIO 4
-- ===============================================
SET SERVEROUTPUT ON;

BEGIN
  DBMS_OUTPUT.PUT_LINE('--- Inicio de transacción ---');

  -- Aumento del 8% en departamento 100
  UPDATE employees
  SET salary = salary * 1.08
  WHERE department_id = 100;
  DBMS_OUTPUT.PUT_LINE('Aumento 8% aplicado al departamento 100.');
  
  SAVEPOINT A;

  -- Aumento del 5% en departamento 80
  UPDATE employees
  SET salary = salary * 1.05
  WHERE department_id = 80;
  DBMS_OUTPUT.PUT_LINE('Aumento 5% aplicado al departamento 80.');

  SAVEPOINT B;

  -- Eliminación de empleados del departamento 50
  DELETE FROM employees
  WHERE department_id = 50;
  DBMS_OUTPUT.PUT_LINE('Empleados del departamento 50 eliminados.');

  -- Reversión parcial al SAVEPOINT B
  ROLLBACK TO SAVEPOINT B;
  DBMS_OUTPUT.PUT_LINE('Reversión realizada hasta SAVEPOINT B.');

  -- Confirmar la transacción
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('--- Transacción confirmada con COMMIT ---');

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error detectado: ' || SQLERRM);
    ROLLBACK;
END;
/