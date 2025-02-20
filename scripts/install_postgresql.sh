#!/bin/sh
## install postgresql with all access
## you must read before of execute


sudo apt update 
sudo apt install PostgreSQL -y

sudo sed -i 's|host\s\+all\s\+all\s\+0.0.0.0/0\s\+peer|host    all             all             0.0.0.0/0               trust|' /etc/postgresql/16/main/pg_hba.conf
sudo -i -u postgres

echo "
CREATE ROLE teste WITH LOGIN PASSWORD 'teste123';
ALTER ROLE teste SUPERUSER CREATEROLE CREATEDB REPLICATION BYPASSRLS;
CREATE DATABASE teste;
" > ./script.sql

psql -f ./script.sql

exit
