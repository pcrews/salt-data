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

mysql-server:
  pkg:
   - installed
   - order: 4

java7-jdk:
  pkg:
    - installed
    - order: 5

lbaas-api-git:
   require:
     - pkg: git
   git.latest:
    - order: 6
    - cwd: /home/ubuntu
    - name: https://github.com/LBaaS/lbaas-api.git
    - target: /home/ubuntu/lbaas-api
    - force: True

add-gearman-m2-repo:
  cmd.run:
    - name: 'mvn install:install-file -DgroupId=gearman -DartifactId=java-gearman-service -Dversion=0.6.5 -Dpackaging=jar -Dfile=gearman/java-gearman-service-0.6.5.jar'
    - cwd: /home/ubuntu/lbaas-api
    - order: 7  

build-lbaas-api:
  require:
    - pkg: git
  cmd.run:
    - name: 'mvn clean install'
    - cwd: /home/ubuntu/lbaas-api
    - order: 8 

build-lbaas-api2:
  require:
    - pkg: git
  cmd.run:
    - name: 'mvn assembly:assembly'
    - cwd: /home/ubuntu/lbaas-api
    - order: 9  

