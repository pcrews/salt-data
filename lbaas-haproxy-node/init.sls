haproxy:
  pkg:
    - installed

/var/www/tester.html:
  file:
    - managed
    - source: salt://lbaas-test-apacheserver/tester.html
    - require:
      - pkg: apache2

