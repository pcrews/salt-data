base:
    # salt-master
    'salt-master*lbaas*':
      - salt-master

    # apply dev team creds to all nodes
    'lbaas*':
      - users

    # lbaas infrastructure
    'lbaas-mysql*':
      - lbaas-mysql
    'lbaas-gearman*':
      - lbaas-gearman
    'lbaas-haproxy*':
      - lbaas-haproxy
    'lbaas-api*':
      - lbaas-api
    'lbaas-poolmgm*':
      - lbaas-pool-mgm

    # test nodes...apache, stressors, etc
    'lbaas-webserver*':
      - lbaas-web   
    'lbaas-stress*':
      - lbaas-stress


