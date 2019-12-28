output "master_ip" {
  value = openstack_networking_floatingip_v2.floatip_1.address
}
output "worker_node1_ip" {
  value = openstack_networking_floatingip_v2.floatip_2.address
}
output "worker_node2_ip" {
  value = openstack_networking_floatingip_v2.floatip_3.address
}


output "workers" {
  value = data.template_file.k8s
}
