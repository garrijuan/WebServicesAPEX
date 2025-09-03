# RESTful Service in Oracle APEX - PIPO Integration

This repository contains the full deployment of a RESTful service built with Oracle APEX and Oracle REST Data Services (ORDS) for data integration

This project focuses on the automated generation and management of REST API endpoints through code, emphasizing Infrastructure as Code (IaC) principles. By defining the RESTful services programmatically, it enables seamless integration with CI/CD pipelines, which ensures that any modifications or additions to the web services are version-controlled, tested, and deployed automatically. This approach provides full control over the development lifecycle of web services, from creation to maintenance, enforcing consistency and repeatability while reducing manual effort and errors. As a result, it facilitates scalable, auditable, and efficient management of API endpoints within modern DevOps workflows.

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
                p_comments => 'CRUD in Web Services stands for Create, Read, Update, and Delete —                 the four fundamental operations performed on data resources through a web service.                ');
COMMIT;
END;
```

- Defines a resource template called `CRUD` within the `integration` module.
- Specifies the URI pattern for requests related to CRUD (e.g., `/integration/v1/CRUD`).

![alt text](/images/template.png "template")

## Handler for GET method

```sh
BEGIN
  ords.define_handler(p_module_name => 'Integration',
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
  ords.define_handler(p_module_name => 'Integration',
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
![alt text](/images/POST.png "POST")

## Parameters

```sh
BEGIN
  ords.define_parameter(p_module_name        => 'Integration',
                        p_pattern            => 'CRUD',
                        p_method             => 'POST',
                        p_name               => 'result_message',
                        p_bind_variable_name => 'pv_result',
                        p_source_type        => 'RESPONSE',
                        p_param_type         => 'STRING',
                        p_access_method      => 'OUT',
                        p_comments           => 'result message');
  COMMIT;
END;
/
BEGIN
  ords.define_parameter(p_module_name        => 'Integration',
                        p_pattern            => 'CRUD',
                        p_method             => 'POST',
                        p_name               => 'STATUS-CODE',
                        p_bind_variable_name => 'pn_status',
                        p_source_type        => 'HEADER',
                        p_param_type         => 'INT',
                        p_access_method      => 'OUT',
                        p_comments           => 'result code message');
  COMMIT;
END;
```
![alt text](/images/parameters.png "parameters")

## OAuth Security

### create Role & Privilege

Sets up a named security role to control who can access the REST endpoints.
ords.define_privilege maps that role to specific URL patterns (e.g., /integration/v1/CRUD).
This restricts access to authenticated users with that role.

```sh
DECLARE
  la_roles         owa.vc_arr;
  la_priv_patterns owa.vc_arr;
BEGIN
  ords.create_role(p_role_name => 'HumanResourceManager');

  la_roles(1)         := 'HumanResourceManager';
  la_priv_patterns(1) := '/Integration/v1/CRUD';

  -- Define a privilege linking the role to the URL pattern
  ords.define_privilege(
    p_privilege_name => 'integrations.humanresources.privilege',
    p_roles          => la_roles,
    p_patterns       => la_priv_patterns,
    p_label          => 'Human Resources Management Access',
    p_description    => 'Access to REST services for Human Resources CRUD operations'
  );

  COMMIT;
END;
/
```

![alt text](/images/role.png "role")

### create Client

To enable secure authentication and login, it is essential first to establish a valid OAuth client within the system. This client will be automatically assigned a unique client identifier (client_id) and a secret key (client_secret), which act as credentials to authenticate and authorize access to protected RESTful services. In the event that this client entity does not already exist, it must be created before initiating any secure token exchange or granting access. This creation step ensures that the client application is recognized and trusted, allowing it to request and receive OAuth tokens, thereby enabling safe and controlled access to your APIs and backend resources.

```sh
BEGIN
  oauth.create_client(p_name => 'HR_DEPARTMENT',
                      p_grant_type       => 'client_credentials',
                      p_description      => 'Client with access to Request CRUD of Employee',
                      p_support_email    => 'support@example.com',
                      p_privilege_names  => NULL);

  COMMIT;
END;
/
```


### Assign Role to the Client

```sh
BEGIN
  oauth.grant_client_role(p_client_name => 'HR_DEPARTMENT',
                          p_role_name   => 'HumanResourceManager');
  COMMIT;
END;
/
```

### Get Client_id y Client_secret

This SQL query is used to retrieve information about an OAuth client registered in Oracle REST Data Services (ORDS) for the client named 'HR_DEPARTMENT'.

-client_id: The unique client identifier string used by the client to authenticate against the OAuth authorization server.
-client_secret: The secret string paired with the client_id, acting as a password to securely authenticate the client.

```sh
SELECT id
      ,NAME
      ,description
      ,client_id
      ,client_secret
  FROM user_ords_clients c
 WHERE NAME = 'HR_DEPARTMENT';
```

![alt text](/images/client_secret.png "client_secret")