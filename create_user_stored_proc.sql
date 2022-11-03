// create utils schema
use role sysadmin;
use database btech;
create schema utils;

// grant privileges
use role securityadmin;
grant usage on database btech to role securityadmin;
grant usage, create procedure on schema btech.utils to role securityadmin;

use schema btech.utils;

// create stored procedure for users
create or replace procedure btech.utils.create_user(first_name varchar,
                                                    last_name varchar,
                                                    email varchar,
                                                    project_name varchar,
                                                    default_role varchar,
                                                    default_warehouse varchar)
    returns varchar
    language sql
    execute as caller
    as
        declare
            user_name varchar := :first_name || :last_name || '_' || :project_name;
            password varchar:= :first_name || :last_name || '123';  -- default password -> <username>123
        begin    
            // create user with given details
            create or replace user identifier(:user_name)
                password = :password
                -- login name = set same as the user name
                -- display_name = set same as the user name
                default_role = :default_role
                first_name = :first_name
                last_name = :last_name
                email = :email
                must_change_password = true  -- fixed security param
                default_warehouse = :default_warehouse;
            
            // grant access to the role
            grant role identifier(:default_role) to user identifier(:user_name);
            
            return 'User ' || :user_name || ' created.';
        end;


// create stored procedure for instances
create or replace procedure btech.utils.create_user(name varchar,
                                                    project_name varchar,
                                                    default_role varchar,
                                                    default_warehouse varchar)
    returns varchar
    language sql
    execute as caller
    as
        declare
            user_name varchar := :name || '_' || :project_name;
            password varchar:= :name || '123';
        begin    
            // create user with given details
            create or replace user identifier(:user_name)
                password = :password
                -- login name = set same as the user name
                -- display_name = set same as the user name
                default_role = :default_role
                must_change_password = true  -- fixed security param
                default_warehouse = :default_warehouse;
            
            // grant access to the role
            grant role identifier(:default_role) to user identifier(:user_name);
            
            return 'User ' || :user_name || ' created.';
        end;