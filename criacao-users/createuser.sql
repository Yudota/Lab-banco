-- ALTER SESSION
alter session set "_ORACLE_SCRIPT" = true;
-- USER SQL
 create user app identified by app123 default tablespace users quota unlimited on users;
 grant connect, resource to app;

-- SYSTEM PRIVILEGES

