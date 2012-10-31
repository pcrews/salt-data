haproxy:
  pkg:
    - installed

git:
  pkg:
   - installed 

gearman-job-server:
  pkg:
    - installed

python-setuptools:
   pkg:
    - installed

/etc/sudoers:
  file:
    - managed
    - source: salt://lbaas-haproxy-node/sudoers
    - user: root
    - mode: 400

libra-git:
   require:
     - pkg: git
   git.latest:
    - cwd: /home/ubuntu
    - name: https://github.com/LBaaS/libra.git
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
