haproxy:
  pkg:
    - installed
    - order: 1 

git:
  pkg:
   - installed 
   - order: 2 

build-essential:
  pkg:
    - installed
    - order: 3 

python-setuptools:
   pkg:
    - installed
    - order: 4

python-dev:
  pkg:
    - installed
    - order: 5

/etc/sudoers:
  file:
    - managed
    - source: salt://lbaas-haproxy/sudoers
    - user: root
    - mode: 400

libra-git:
   require:
     - pkg: git
   git.latest:
    - cwd: /home/ubuntu
    - name: https://github.com/stackforge/libra.git
    - target: /home/ubuntu/libra
    - force: True

setup-libra-worker:
  require:
    - pkg: git
    - pkg: python-setuptools
  cmd.run:
    - name: 'sudo python setup.py install'
    - cwd: /home/ubuntu/libra
    - order: last
