-- ===============================================
-- LABORATORIO DE TRANSACCIONES - EJERCICIO 2
-- ===============================================
SELECT sys_context('USERENV','SID') AS session_id, user FROM dual;
-- SESIÓN 2
UPDATE employees
SET salary = salary + 1000
WHERE employee_id = 103;