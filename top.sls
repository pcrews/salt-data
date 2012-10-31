base:
    'lbaas*':
      - users
    'salt-master*lbaas*':
      - salt-master
    'lbaas-webserver*':
      - lbaas-apache 
    'lbaas-stress*':
      - lbaas-stress
    'lbaas-haproxy*':
      - lbaas-haproxy
    'lbaas-api*':
      - lbaas-api
