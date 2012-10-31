salt-master:
  pkg:
    - latest 
  service.running:
    - require:
      - file: /etc/salt/master
      - pkg: salt-master
    - watch:
        - file: /etc/salt/master

/etc/salt/master:
  file.managed:
    - source: salt://salt-master/master
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: salt-master

