-- ===============================================
-- LABORATORIO DE TRANSACCIONES - EJERCICIO 3
-- ===============================================
SET SERVEROUTPUT ON;

DECLARE
  v_emp_id        NUMBER := 104;
  v_new_dept_id   NUMBER := 110;
  v_old_dept_id   NUMBER;
  v_job_id        employees.job_id%TYPE;
  v_start_date    DATE;
BEGIN
  -- Obtener datos actuales del empleado
  SELECT department_id, job_id, hire_date
  INTO v_old_dept_id, v_job_id, v_start_date
  FROM employees
  WHERE employee_id = v_emp_id;

  -- Actualizar el departamento del empleado
  UPDATE employees
  SET department_id = v_new_dept_id
  WHERE employee_id = v_emp_id;

  -- Insertar registro en JOB_HISTORY
  INSERT INTO job_history (employee_id, start_date, end_date, job_id, department_id)
  VALUES (v_emp_id, v_start_date, SYSDATE, v_job_id, v_old_dept_id);

  -- Confirmar los cambios
  COMMIT;

  DBMS_OUTPUT.PUT_LINE('Transferencia realizada correctamente: Empleado ' || v_emp_id ||
                       ' del Dpto ' || v_old_dept_id || ' al Dpto ' || v_new_dept_id);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Error: El empleado no existe.');
    ROLLBACK;
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
    ROLLBACK;
END;
/
