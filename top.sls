base:
    'lbaas-test-webserver*':
        - lbaas-test-apacheserver 
    'lbaas-test-stress*':
        - lbaas-test-stress-server
    'lbaas-haproxy-node*':
        - lbaas-haproxy-node
    'salt-master*':
        - salt-master
    '*':
        - salt-minion
