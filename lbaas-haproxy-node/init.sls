haproxy:
  pkg:
    - installed

/etc/sudoers:
  file:
    - managed
    - source: salt://lbaas-haproxy-node/sudoers
    - user: root
    - mode: 400

/home/ubuntu/libra:
  file.directory:
    - user: root
    - group: root
    - makedirs: True

libra.git:
   git.clone:
    - cwd: /home/ubuntu/libra
    - repository: https://github.com/LBaaS/libra.git
#    - require:
#      - file: /home/ubuntu/libra

setup-libra-worker:
  cmd.wait:
    - name: 'sudo python setup.py install'
    - cwd: /home/ubuntu
    - require:
      - file: /home/ubuntu/libra
