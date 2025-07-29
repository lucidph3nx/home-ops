# Cilium

## UniFi BGP

```sh
router bgp 64513
  bgp router-id 10.87.42.1
  no bgp ebgp-requires-policy

  neighbor k8s peer-group
  neighbor k8s remote-as 64514

  neighbor 10.87.42.100 peer-group k8s
  neighbor 10.87.42.101 peer-group k8s
  neighbor 10.87.42.102 peer-group k8s
  neighbor 10.87.42.103 peer-group k8s

  address-family ipv4 unicast
    neighbor k8s next-hop-self
    neighbor k8s soft-reconfiguration inbound
  exit-address-family
exit
```
