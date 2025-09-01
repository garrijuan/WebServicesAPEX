# RESTful Service in Oracle APEX - PIPO Integration

This repository contains the full deployment of a RESTful service built with Oracle APEX and Oracle REST Data Services (ORDS) for data integration

## Module
```sh
BEGIN
    ords.define_module(p_module_name => 'Integration',
                    p_base_path => 'Integration/v1/',
                    p_items_per_page => 50,
                    p_status => 'PUBLISHED',
                    p_comments => 'Data integrations between 3er system and APEX');
COMMIT;
END;
```

- Defines a REST module (`integration`) that groups related resources under the base path `/Integration/v1/`.
- Sets default pagination to 50 items per page and marks the module as published to make it available.
- The comment describes the overall purpose of the module.

![alt text](/images/module.png "module")

## Template

```sh
BEGIN
ords.define_template(p_module_name => 'Integration',
p_pattern => 'CRUD',
p_comments => 'CRUD in Web Services stands for Create, Read, Update, and Delete — the four fundamental operations performed on data resources through a web service.');
COMMIT;
END;
```

- Defines a resource template called `CRUD` within the `integration` module.
- Specifies the URI pattern for requests related to CRUD (e.g., `/integration/v1/CRUD`).

![alt text](/images/template.png "template")

## Handler for GET method

```sh
BEGIN
  ords.define_handler(p_module_name => 'integration',
                      p_pattern     => 'CRUD',
                      p_method      => 'GET',
                      p_source_type => ords.source_type_plsql,
                      p_source      => 'DECLARE
                        ....your code to read data...
                        END;
                      ',
                      p_comments    => 'Get Employee info');
  COMMIT;
END;
```
## Handler for POST method

```sh
BEGIN
  ords.define_handler(p_module_name => 'integration',
                      p_pattern     => 'CRUD',
                      p_method      => 'POST',
                      p_source_type => ords.source_type_plsql,
                      p_source      => 'DECLARE
                        ....your code to insert data...
                        END;
                      ',
                      p_comments    => 'Get Employee info');
  COMMIT;
END;
```

## Variables



## OAuth Security

