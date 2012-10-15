base:
    'lbaas-test-webserver*':
        - lbaas-test-apacheserver 
    'lbaas-test-stress*':
        - lbaas-test-stress-server
    'server-1350340245-az-3-region-a-geo-1.novalocal':
      - lbaas-haproxy-node
