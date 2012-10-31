git:
  pkg:
    - installed
    - order: 1

maven:
  pkg:
   - installed 
   - order: 2

gearman-job-server:
  pkg:
    - installed
    - order: 3

java7-jdk:
  pkg:
    - installed
    - order: 4 

lbaas-api-git:
   require:
     - pkg: git
   git.latest:
    - order: 5 
    - cwd: /home/ubuntu
    #- name: https://github.com/LBaaS/lbaas-api.git
    - name: https://github.com/pcrews/lbaas-api.git
    - target: /home/ubuntu/lbaas-api
    - force: True

add-gearman-m2-repo:
  cmd.run:
    - name: 'mvn install:install-file -DgroupId=gearman -DartifactId=java-gearman-service -Dversion=0.6.5 -Dpackaging=jar -Dfile=gearman/java-gearman-service-0.6.5.jar'
    - cwd: /home/ubuntu/lbaas-api
    - order: 6  

build-lbaas-api:
  require:
    - pkg: git
  cmd.run:
    - name: 'mvn clean install'
    - cwd: /home/ubuntu/lbaas-api
    - order: 7 

build-lbaas-api2:
  require:
    - pkg: git
  cmd.run:
    - name: 'mvn assembly:assembly'
    - cwd: /home/ubuntu/lbaas-api
    - order: 8  

python-mysqldb:
  pkg:
    - installed
    - order: 9 

mysql-server:
  pkg:
   - installed
   - order: 10

# initialize / create the db's
# only do this if the db doesn't exist
install-lbaas-db:
  cmd.run:
    - name: 'mysql -uroot < mysql/lbaas.sql'
    - cwd: /home/ubuntu/lbaas-api
    - unless: 'mysql -uroot -e "SHOW TABLES IN lbaas"' 
    - order: 11

# mysql-lbaas user
lbaas:
  mysql_user.present:
    - host: localhost
    - password_hash: '*44547F3114959B118AD02CBAB98C322F56007386'
    - order: 12

# make logs dir
/home/ubuntu/lbaas-api/logs:
  file.directory:
    - group: users
    - mode: 755
    - makedirs: True
    - order: 13

start-api-server:
  cmd.run:
   - name: './lbaas.sh start'
   - cwd: /home/ubuntu/lbaas-api
   - order: last 

# TODO: check the server is running
# parse the log maybe?
