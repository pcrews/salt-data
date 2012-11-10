git:
  pkg:
    - installed
    - order: 1

python-mysqldb:
  pkg:
    - installed
    - order: 13 

mysql-server:
  pkg:
   - installed
   - order: 14

/home/ubuntu/lbaas.sql:
  file:
    - managed
    - source: salt://lbaas-mysql/lbaas.sql
    - require:
      - pkg: mysql-server 

    
# initialize / create the db's
# only do this if the db doesn't exist
install-lbaas-db:
  cmd.run:
    - name: 'mysql -uroot < ./lbaas.sql'
    - cwd: /home/ubuntu
    - unless: 'mysql -uroot -e "SHOW TABLES IN lbaas"' 
    - require:
      - file: /home/ubuntu/lbaas.sql 

mysql-minion:
  file.append:
  - name: /etc/salt/minion
  - text: |
       # MySQL-module-specific data
       mysql.host: 'localhost'
       mysql.port: 3306
       mysql.user: 'root'
       mysql.pass: ''
       mysql.db: 'mysql'
  - require:
    - pkg: mysql-server
    - pkg: python-mysqldb

# mysql-lbaas user
lbaas:
  mysql_user.present:
    - host: localhost
    - password_hash: '*44547F3114959B118AD02CBAB98C322F56007386'
    - require:
      - cmd: install-lbaas-db 
