apache2:
  pkg:
    - installed
  service:
    - running

/var/www/tester.html:
  file:
    - managed
    - source: salt://lbaas-test-apacheserver/tester.html
    - require:
      - pkg: apache2

/var/www/csj.mp4:
    file:
      - managed
      - source: salt://lbaas-test-apacheserver/csj.mp4
      - require:
        - pkg:  apache2

/var/www/1k-static.html:
  file:
    - managed
    - source: salt://lbaas-test-apacheserver/1k-static.html
    - require:
      - pkg: apache2

/var/www/ssl-protected:
  file.directory:
    - user: root 
    - group: root  
    - makedirs: True

/var/www/ssl-protected/ssl-tester.html:
  file:
    - managed
    - source: salt://lbaas-test-apacheserver/ssl-tester.html
    - require:
      - pkg: apache2
      - file: /var/www/ssl-protected

/usr/lib/cgi-bin/ident-cgi.py:
  file:
    - managed
    - source: salt://lbaas-test-apacheserver/ident-cgi.py
    - require:
      - pkg:  apache2
    - mode: 777

/usr/lib/cgi-bin/1k-random.py:
  file:
    - managed
    - source: salt://lbaas-test-apacheserver/1k-random.py
    - require:
      - pkg:  apache2
    - mode: 777

/etc/apache2/sites-available/default:
  file:
    - managed
    - source: salt://lbaas-test-apacheserver/default
    - require:
      - pkg: apache2

{% macro a2enmod(module) -%}
apache2-enable-mod-{{ module }}:
   cmd.run:
     - name: a2enmod {{ module }}
     - unless: test -f '/etc/apache2/mods-enabled/{{ module }}.load'
     - require:
       - pkg: apache2
     - watch_in:
       - service: apache2
{%- endmacro %}

{{ a2enmod('ssl') }}
