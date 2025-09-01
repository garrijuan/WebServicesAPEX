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

- Defines a REST module (`integration`) that groups related resources under the base path `/integration/v1/`.
- Sets default pagination to 50 items per page and marks the module as published to make it available.
- The comment describes the overall purpose of the module.

![alt text](/images/module.png "module")