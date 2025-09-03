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
  ords.define_handler(p_module_name => 'Integration',
                      p_pattern     => 'CRUD',
                      p_method      => 'POST',
                      p_source_type => ords.source_type_plsql,
                      p_source      => '
      DECLARE
        l_json       JSON_OBJECT_T := JSON_OBJECT_T(:body);
        l_first_name VARCHAR2(100);
        l_last_name  VARCHAR2(100);
        l_email      VARCHAR2(200);
        l_phone      VARCHAR2(50);
        l_hire_date  DATE;
        l_job_title  VARCHAR2(100);
        l_department VARCHAR2(100);
        l_salary     NUMBER;
        l_manager_id NUMBER;
      BEGIN
        -- Extraemos los valores del JSON
        l_first_name := l_json.get_string(''first_name'');
        l_last_name  := l_json.get_string(''last_name'');
        l_email      := l_json.get_string(''email'');
        l_phone      := l_json.get_string(''phone'');
        l_hire_date  := TO_DATE(l_json.get_string(''hire_date''), ''YYYY-MM-DD'');
        l_job_title  := l_json.get_string(''job_title'');
        l_department := l_json.get_string(''department'');
        l_salary     := l_json.get_number(''salary'');
        l_manager_id := l_json.get_number(''manager_id'');
        
        -- Insertamos en la tabla employee
        INSERT INTO employee 
          (first_name, last_name, email, phone, hire_date, job_title, department, salary, manager_id)
        VALUES
          (l_first_name, l_last_name, l_email, l_phone, l_hire_date, l_job_title, l_department, l_salary, l_manager_id);
        
        COMMIT;
        
        -- Respuesta JSON simple con éxito
        owa_util.mime_header(''application/json'', TRUE);
        htp.p(''{"status":"success","message":"Employee inserted"}'');
      EXCEPTION
        WHEN OTHERS THEN
          -- Respuesta de error JSON
          owa_util.mime_header(''application/json'', TRUE);
          htp.p(''{"status":"error","message":"'' || SQLERRM || ''"}'');
      END;
    ',
                      p_comments    => 'create New employee');
  COMMIT;
END;
//