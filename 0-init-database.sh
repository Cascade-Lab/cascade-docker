#!/bin/bash

psql -v ON_ERROR_STOP=1 --username "postgres" --dbname "postgres" <<-EOSQL
    CREATE ROLE cascade WITH LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE
    NOINHERIT REPLICATION CONNECTION LIMIT -1 PASSWORD '$(< /run/secrets/db_password)';
EOSQL

psql -v ON_ERROR_STOP=1 --username "postgres" --dbname "postgres" <<-EOSQL
    CREATE DATABASE cascade WITH OWNER = cascade ENCODING = 'UTF8'
    CONNECTION LIMIT = -1;
EOSQL

psql -v ON_ERROR_STOP=1 --username "postgres" --dbname "cascade" <<-EOSQL
    \c cascade;
    GRANT ALL ON SCHEMA public TO cascade;
    CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
    CREATE EXTENSION IF NOT EXISTS "unaccent";
EOSQL