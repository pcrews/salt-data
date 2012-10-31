=====
salt-data
=====

files for salt and salt-cloud to facilitate
testing / working with the libra lbaas code

These files will enable one to create and configure vm's for:
 - the lbaas api server
 - the libra gearman worker nodes
 - the pool manager
 - apache test servers
 - stress servers

saltstack
-----------

The primary requirement for working with this data is saltstack.
All states were written / tested against ubuntu 12.04 vm's on hp's cloud

Primary documentation is located here and includes information on installation and configuration:

http://docs.saltstack.org/en/latest/index.html

The file is intended to serve as the file server root as noted here:

http://docs.saltstack.org/en/latest/topics/tutorials/states_pt1.html#setting-up-the-salt-state-tree

The salt-cloud map files are intended to work with the naming conventions used in the top.sls file

The primary assumption is that this data will live on a salt-master and that minions will be created via salt-cloud.

salt-cloud
----------
https://salt-cloud.readthedocs.org/en/latest/

salt-cloud is a tool that facilitates working with cloud instances and coordinating them via a salt-master
Through the mapping and profile files, one can quickly create vm's and then configure them with salt.
salt-cloud's delete functionality facilitates quick disposal of test vm's as well.

Configuration information is here:

https://salt-cloud.readthedocs.org/en/latest/topics/config.html

For working with HP Cloud, there are additional notes.
We are currently working with the salt-cloud / libcloud upstream maintainers to integrate our code to work with HP's cloud
In the interim, libcloud and salt-cloud code that will work can be found here:

  - libcloud: https://github.com/pcrews/libcloud
  - saltcloud: https://github.com/pcrews/salt-cloud

The primary changes are the introduction of some polling code to ensure vm's are ready / that we have public ip's available in libcloud and code to deal with HP-specific credentials in salt-cloud.  Efforts are being taken to merge this code into a single OpenStack provider for salt-cloud.

::

 cat /etc/salt/cloud
 HPCLOUD.user: GENERAL_USER_NAME
 HPCLOUD.apikey: THIS_IS_YOUR_CONSOLE_PW
 HPCLOUD.tenant_name: TENANT_NAME_FOR_USER
 HPCLOUD.auth_endpoint: https://region-a.geo-1.identity.hpcloudsvc.com:35357/v2.0/
 HPCLOUD.region: az-N.region-a.geo-1 # desired hp region
 HPCLOUD.keyname: this-is-my-example-keyname # name of key in openstack 

 minion:
  master: # name / ip address of the salt-master 

 cat /etc/salt/cloud.profiles
 base_hp_az3:
  provider: hpcs
  image: 120 
  size: 102
  os: ubuntu
  ssh_username: ubuntu

map files
---------

Map files can be used to specify sets of vm's that one wants to create based on salt-cloud profile information.
An example::

 /home/ubuntu# cat testmap.dat 
 base_hp_az3:
  - lbaas-api11
  - lbaas-api22

This means that if one calls salt-cloud to use this mapfile, that two servers - lbaas-api11 and lbaas-api22 - will be created based on the base_hp_az3 profile.

To create the vm's (the -P option is used to create the vm's in parallel)

::

 /home/ubuntu# time salt-cloud -P -m testmap.dat 
 The following virtual machines are set to be created:
   lbaas-api22
   lbaas-api11

 Proceed? [N/y]y
 Creating Cloud VM lbaas-api22
 Creating Cloud VM lbaas-api11
 <snip> The tool will bootstrap salt and register it with the specified master
 Salt installed on lbaas-api11
 Created Cloud VM lbaas-api11 with the following values:
  private_ips: [...]
  extra: {'updated': '2012-13-31T20:14:42Z', 'hostId': 'this_is_sample_hostId', 'created': '2012-13-31T20:14:23Z', 'key_name': 'mah_security_key', 'uri': 'https://my_server_uri', 'imageId': '42', 'metadata': {}, 'password': 'thisisnotarealpw', 'flavorId': '7', 'tenantId': '6'}
  image: None
  _uuid: None
  driver: <libcloud.compute.drivers.openstack.OpenStack_1_1_NodeDriver object at 0x15b6f10>
  state: 0
  public_ips: [...]
  size: None
  id: 3939
  name: lbaas-api11

 real	1m26.749s
 user	0m3.788s
 sys	0m0.180s

Once finished, the nodes will be registered with the salt-master

::

 /home/ubuntu# salt 'lbaas-api*' test.ping
 lbaas-api11: True
 lbaas-api22: True

To configure them, call state.highstate (one can target minions in a variety of ways - please refer to salt docs)

::

 /home/ubuntu# time salt 'lbaas-api*' state.highstate

 ----------
    State: - cmd
    Name:      ./lbaas.sh start
    Function:  run
        Result:    True
        Comment:   Command "./lbaas.sh start" run
        Changes:   pid: 12212
                   retcode: 0
                   stderr: 
                   stdout: starting lbaas ...
 application : ./target/lbaas-0.0.1-jar-with-dependencies.jar
 logging cfg : file:/home/ubuntu/lbaas/lbaas-10-24-2012/log4j.properties
 started
                   

 real	2m56.536s
 user	0m0.304s
 sys	0m0.056s

The above example completed all of the steps necessary to create, build, and start an lbaas-api server and it was done quickly!

