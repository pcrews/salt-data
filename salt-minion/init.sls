salt:
  pkg:
    - installed
  service.running:
    - require:
      - file: /etc/salt/minion
      - pkg: salt
    - watch:
        - file: /etc/salt/minion

/etc/salt/minion:
    file.managed:
    - source: salt://salt/salt-minion/minion
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: salt