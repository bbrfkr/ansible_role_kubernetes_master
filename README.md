# ansible_role_kubernetes_master

This is an Ansible role. This role executes Kubernetes setting of master node.

## Processing
This role executes the following settings.

* Kubernetes setting
  * put kubernetes common setting
  * create certification and key for service account
  * put api server config
  * put controller-manager config
  * start and enable services
* etcd setting
  * put config
  * start and enable service
  * create management directory of etcd
  * create key of etcd
* flannel setting
  * put config
  * start and enable service

## Caution!!
* This role assumpts a part of network settings (nics, default gateway and dns server) is completed.
* This role assumpts NetworkManager service is disabled and stopped.

## Support OS

| OS | version |
|----|---------|
|CentOS|7|


## Role variables
```
kubernetes_master:
  hostname: k8s-master                    # hostname of target
  api_port: 8080                          # listen port of api server
  kubelet_port: 10250                     # listen port for kubelet service of minion node
  service_cluster_network: 10.254.0.0/19  # network for cluster ips of services
  cert_and_key:
    put_dir: /etc/kubernetes/ssl          # location of certification and key
    valid_term: 7305                      # valid term of certification
    common_name: 192.168.1.115            # common name for registration of certification
  etcd_mgmt_dir: /kube-centos/network     # management directory of etcd
  allow_privileged: true                  # whether allow to create privileged container   
```

## Dependencies
None

## Build status
|branch|status|
|------|------|
|master|[![Build Status](http://jenkins.bbrfkr.mydns.jp:8088/job/ansible_role_kubernetes_master_master/badge/icon)](http://jenkins.bbrfkr.mydns.jp:8088/job/ansible_role_kubernetes_master_master/)|
|v.0.1 |[![Build Status](http://jenkins.bbrfkr.mydns.jp:8088/job/ansible_role_kubernetes_master_v.0.1/badge/icon)](http://jenkins.bbrfkr.mydns.jp:8088/job/ansible_role_kubernetes_master_v.0.1/)|

## Retest
This role is tested by serverspec, then its test codes are included in repository. Users can retest this role by using the test codes. To retest this role, follow the steps described below.

1. Prepare 1 targets (Here, targets ip are X.X.X.X)
2. Install serverspec in local machine
3. Modify spec/inventory.yml
```
---
- conn_name: target15  # never change!
  conn_host: X.X.X.X   # target ip
  conn_port: 22        # target's ssh port
  conn_user: vagrant   # user to connect
  conn_pass: vagrant   # password of user
  conn_idkey:          # path of identity key 
                       # (absolute path or relative path from the location of Rakefile)
  sudo_pass:           # sudo password of user
```

4. Modify targets ips in any files of `spec` dir
```
$ sed -i 's/192\.168\.1\.115/X.X.X.X/g' `find spec -type f`
```

5. Run `rake`

## License
MIT

## Author
Name: bbrfkr  
MAIL: bbrfkr@gmail.com

