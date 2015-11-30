#!/bin/bash

# Filename: postgresql-install-local.sh
# Author:   Adrian Torrie
# Date:     2015-07-20

# References:
#   - http://serverfault.com/questions/110154/whats-the-default-superuser-username-password-for-postgres-after-a-new-install
#   - http://dba.stackexchange.com/questions/57723/superuser-is-not-permitted-to-login
# 
#   - https://help.ubuntu.com/community/IptablesHowTo
#   - http://serverfault.com/questions/219682/connect-to-postgres-remotely-open-port-5432-for-postgres-in-iptables
# 
#   - http://www.postgresql.org/docs/9.3/static/admin.html
#   - http://www.liquidweb.com/kb/how-to-install-and-connect-to-postgresql-on-ubuntu-14-04/
#   - https://help.ubuntu.com/lts/serverguide/postgresql.html
# 
#   - https://stackoverflow.com/questions/1137060/where-does-postgresql-store-the-database/8237512#8237512

# start psql with postgres user credentials
sudo -u postgres psql template1
ALTER USER postgres with encrypted password '12345678987654321';

# Change postgres rules to listen for remote connections
sudo vi /etc/postgresql/9.4/main/postgresql.conf
# listen_addresses = '*'          # what IP address(es) to listen on;

# Edit permissions to allow for conenctions
sudo vi /etc/postgresql/9.4/main/pg_hba.conf
# -> #  TYPE    DATABASE        USER            ADDRESS                 METHOD
# ->    local   all             postgres                                md5
# ->    local   all             adrian                                  trust
# ->    host    all             adrian          192.168.1.0/24          md5

# open port on ubuntu server firewall to allow connections from the local network
sudo iptables -L
sudo iptables -A INPUT -p tcp --dport 5432 -s 192.168.1.0/24 -j ACCEPT

#  apply changes
sudo service postgresql restart

# search your server for file locations for the postgresql server
sudo find / -iname postgresql
# ->    /usr/share/postgresql
# ->    /usr/share/doc/postgresql
# ->    /usr/lib/postgresql
# ->    /var/lib/postgresql
# ->    /var/log/postgresql
# ->    /var/cache/postgresql
# ->    /etc/init.d/postgresql
# ->    /etc/postgresql

# check the running process
ps auxw |  grep postgres | grep -- -D

# change to postgres user (user is created when db server is installed)
# and create my superuser account
# exit to bash (\q)
sudo -u postgres psql postgres
\d+ pg_authid;
select rolname from pg_authid;
create role adrian with login superuser encrypted password '123';
\q

# create a db called 'dev'quickly, and connect to the 'dev' database
createdb dev
psql dev

# check runtime variables of the postgres server using this query
#  - http://stackoverflow.com/a/8237512/893766
show all;
