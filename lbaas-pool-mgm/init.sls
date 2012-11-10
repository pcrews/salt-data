git:
  pkg:
   - installed 

build-essential:
  pkg:
    - installed

python-setuptools:
   pkg:
    - installed

python-dev:
  pkg:
    - installed

libra-git:
   require:
     - pkg: git
     - pkg: python-setuptools
     - pkg: build-essential
     - pkg: python-dev
   git.latest:
    - cwd: /home/ubuntu
    - name: https://github.com/stackforge/libra.git
    - target: /home/ubuntu/libra
    - force: True

setup-libra:
  require:
     - pkg: git
     - pkg: python-setuptools
     - pkg: build-essential
     - pkg: python-dev
  cmd.run:
    - name: 'sudo python setup.py install'
    - cwd: /home/ubuntu/libra
    - order: last
