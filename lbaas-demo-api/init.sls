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

debconf-utils:
  pkg:
    - installed
    - order: 4

add-oracle-ppa:
  cmd.run:
    - name: 'sudo add-apt-repository ppa:webupd8team/java -y'
    - order: 5 

update-repo:
  cmd.run:
    - name: 'sudo apt-get update'
    - order: 6 

update-debconf:
  cmd.run:
    - name: 'echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections'
    - order: 6

update-debconf2:
  cmd.run:
    - name: ' echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections'
    - order: 7

install-oracle-java7:
  cmd.run:
    - name: 'sudo apt-get -y install oracle-java7-installer'
    - order: 8  

lbaas-api-git:
   require:
     - pkg: git
   git.latest:
    - order: 9 
    - cwd: /home/ubuntu
    #- name: https://github.com/LBaaS/lbaas-api.git
    - name: https://github.com/pcrews/lbaas-api.git
    - target: /home/ubuntu/lbaas-api
    - force: True

add-gearman-m2-repo:
  cmd.run:
    - name: 'mvn install:install-file -DgroupId=gearman -DartifactId=java-gearman-service -Dversion=0.6.5 -Dpackaging=jar -Dfile=gearman/java-gearman-service-0.6.5.jar'
    - cwd: /home/ubuntu/lbaas-api
    - order: 10  

build-lbaas-api:
  require:
    - pkg: git
  cmd.run:
    - name: 'mvn clean install'
    - cwd: /home/ubuntu/lbaas-api
    - order: 11 

build-lbaas-api2:
  require:
    - pkg: git
  cmd.run:
    - name: 'mvn assembly:assembly'
    - cwd: /home/ubuntu/lbaas-api
    - order: 12  

python-mysqldb:
  pkg:
    - installed
    - order: 13 

mysql-server:
  pkg:
   - installed
   - order: 14

# initialize / create the db's
# only do this if the db doesn't exist
install-lbaas-db:
  cmd.run:
    - name: 'mysql -uroot < mysql/lbaas.sql'
    - cwd: /home/ubuntu/lbaas-api
    - unless: 'mysql -uroot -e "SHOW TABLES IN lbaas"' 
    - order: 15

# mysql-lbaas user
lbaas:
  mysql_user.present:
    - host: localhost
    - password_hash: '*44547F3114959B118AD02CBAB98C322F56007386'
    - order: 16

# make logs dir
/home/ubuntu/lbaas-api/logs:
  file.directory:
    - group: users
    - mode: 755
    - makedirs: True
    - order: 17

start-api-server:
  cmd.run:
   - name: './lbaas.sh start'
   - cwd: /home/ubuntu/lbaas-api
   - order: last 

# TODO: check the server is running
# parse the log maybe?
