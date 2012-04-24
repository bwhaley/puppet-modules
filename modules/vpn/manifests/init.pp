# This configuration will establish a connection to one of the two AWS tunnels in a VPC VPN
# Use the module on two instances to two VPNs, like this
#   Linux Box #1     Tunnel 1 -> AWS VPC End Point #1           Established
#                    Tunnel 2 -> AWS VPC End Point #2           Ignored
#   Linux Box #2     Tunnel 1 -> AWS VPC End Point #1           Ignored
#                    Tunnel 2 -> AWS VPC End Point #2           Established
#
# This instance can also be used as a NAT for nodes in private subnets


# TODO: Use Nagios EventHandlers to automatically switch routing if an instance fails

class vpn {

  # I define these in hiera. Define them locally or in the 
  # node definition if hiera is not being used 

  $psk = hiera('psk')                           # The pre-shared key (provided by aws)
  $bgp_passwd = hiera('bgp_passwd')             # Arbitrary password for BGP tools
  $bgp_asn = hiera('bgp_asn')                # ASN used when creating customer gateway
  $source_subnet = hiera('source_subnet')       # local subnet to route traffic from
  $dest_subnet = hiera('dest_subnet')           # destination subnet to route traffic to
  $local_address = hiera('local_address')       # e.g. 169.254.255.2 (provided by aws)
  $peer_address = hiera('peer_address')         # e.g. 169.254.255.1 (provided by aws)

  # set routable address of the VPN endpoint (provided by aws)
  # Use .193 if this node is in availability zone a
  # Use .225 if this node is in availability zone b
  if $ec2_placement_availability_zone =~ /a$/ {
    $endpoint = '72.21.209.193'
  } elsif $ec2_placement_availability_zone =~ /b$/ {
    $endpoint = '72.21.209.225'
  }

  Package { 
    ensure => present,
    require => Yumrepo['epel'],
  }

  package { [
    'ipsec-tools',
    'quagga',
    ]:
      ensure  => present,
  }

  exec {  
    # ip_forwarding to route packets
    'ip_forward': 
      command => '/sbin/sysctl -w net.ipv4.ip_forward=1',
      unless  => "/sbin/sysctl net.ipv4.ip_forward | grep '1$'",
      ;
    # Add the tunnel address for peering to VPN endpoint:
    'add_tunnel_ip':
      command => "/sbin/ip a a ${local_address}/30 dev eth0", 
      unless  => "/sbin/ip addr show | grep ${local_address}",
      ;
    # Establish security policies 
    'ipsec-sp':
      command => '/sbin/setkey -f /etc/racoon/ipsec.conf', 
      unless  => "/sbin/setkey -D | grep '${ipaddress} ${endpoint}'",
      require =>  File['/etc/racoon/ipsec.conf'],
      ;
  }
  
  File {
    ensure  =>  present,
    owner   =>  root,
    group   =>  root,
    mode    =>  644,
    require =>  [ Package['ipsec-tools'], Package['quagga'] ],
  }

  file {
    '/etc/racoon/racoon.conf':
      content   =>  template('vpn/racoon.conf.erb'),
      notify    =>  Service['racoon'],
      ;
    '/etc/racoon/ipsec.conf':
      content   =>  template('vpn/ipsec.conf.erb'),
      require   =>  File['/etc/racoon/racoon.conf'],
      notify    =>  Service['racoon'],
      ;
    '/etc/racoon/psk.txt':
      mode      =>  600,
      content   =>  template('vpn/psk.txt.erb'),
      require   =>  File['/etc/racoon/racoon.conf'],
      notify    =>  Service['racoon'],
      ;
    '/etc/sysconfig/iptables':
      mode      =>  600,
      content   =>  template('vpn/iptables.erb'),
      notify    =>  Service['iptables'],
      ;
    '/etc/quagga/zebra.conf':
      content   =>  template('vpn/zebra.conf.erb'),
      notify    =>  Service['zebra'],
      ;
    '/etc/quagga/bgpd.conf':
      content   =>  template('vpn/bgpd.conf.erb'),
      require   =>  File['/etc/quagga/zebra.conf'],
      notify    =>  Service['bgpd'],
      ;
  }

  service {
    'iptables':
      ensure  => running,
      enable  => true,
      ;
    'racoon':
      ensure  => running,
      enable  => true,
      require   =>  Exec['ipsec-sp'],
      ;
    'zebra':
      ensure  => running,
      enable  => true,
      require   =>  Service['racoon'],
      ;
    'bgpd':
      ensure  => running,
      enable  => true,
      require   =>  Service['zebra'],
      ;
  }
  
}

