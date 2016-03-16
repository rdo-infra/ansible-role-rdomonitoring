# Deploy RabbitMQ, Redis, Sensu and Uchiwa
include ::rabbitmq
include ::redis

# OpenStack VMs have a butchered .openstacklocal fqdn
# Rely on ec2_hostname fact if it's available or fall back to fqdn
if $::ec2_hostname {
  $client_name = $::ec2_hostname
} else {
  $client_name = $::fqdn
}

class { 'sensu':
  client_name   => $client_name,
  subscriptions => ['default', 'master']
}

include ::uchiwa
Service['sensu-api'] -> Service['uchiwa']
Yumrepo['sensu'] -> Package['uchiwa']
