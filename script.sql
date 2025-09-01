---------------------------------------
------------- Module -----------------
---------------------------------------
BEGIN
    ords.define_module(p_module_name => 'Integration',
                    p_base_path => 'Integration/v1/',
                    p_items_per_page => 50,
                    p_status => 'PUBLISHED',
                    p_comments => 'Data integrations between 3er system and APEX');
COMMIT;
END;
/
---------------------------------------
------------- Template ----------------
---------------------------------------
BEGIN
ords.define_template(p_module_name => 'Integration',
p_pattern => 'CRUD',
p_comments => 'CRUD in Web Services stands for Create, Read, Update, and Delete — the four fundamental operations performed on data resources through a web service.');
COMMIT;
END;
/
---------------------------------------
------------- Handler -----------------
---------------------------------------
--Create GET Request
BEGIN
  ords.define_handler(p_module_name => 'integration',
                      p_pattern     => 'CRUD',
                      p_method      => 'GET',
                      p_source_type => ords.source_type_plsql,
                      p_source      => 'DECLARE
                        ....
                        END;
                      ',
                      p_comments    => 'Get Employee info');
  COMMIT;
END;
/
--Create POST Request
BEGIN
  ords.define_handler(p_module_name => 'integration',
                      p_pattern     => 'CRUD',
                      p_method      => 'POST',
                      p_source_type => ords.source_type_plsql,
                      p_source      => 'DECLARE
                        INSERT INTO employees 
                        (first_name, last_name, email, phone, hire_date, job_title, department, salary, manager_id)
                        VALUES 
                        (''John'', ''Doe'', ''john.doe@example.com'', ''555-1234'', SYSDATE, ''Software Engineer'', ''IT'', 60000, NULL);
                        END;
                      ',
                      p_comments    => 'create New employee');
  COMMIT;
END;
/