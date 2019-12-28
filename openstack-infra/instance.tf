#create private network
resource "openstack_networking_network_v2" "k8s_private_net" {
  name = "k8s_private_net"
  admin_state_up = "true"
}
resource "openstack_networking_subnet_v2" "k8s_private_subnet" {
  name = "k8s_private_subnet"
  network_id = openstack_networking_network_v2.k8s_private_net.id 
  cidr = "192.168.199.0/24"
  ip_version = 4
}

# create router
resource "openstack_networking_router_v2" "k8s_router" {
  name = "k8s_router"
  external_network_id = var.openstack_external_network_id
}
# add interface
resource "openstack_networking_router_interface_v2" "k8s_router_interface_1" {
  router_id = openstack_networking_router_v2.k8s_router.id
  subnet_id = openstack_networking_subnet_v2.k8s_private_subnet.id
}

# create floating ips
resource "openstack_networking_floatingip_v2" "floatip_1" {
  pool = "public1"
}
resource "openstack_networking_floatingip_v2" "floatip_2" {
  pool = "public1"
}
resource "openstack_networking_floatingip_v2" "floatip_3" {
  pool = "public1"
}

# import public key
resource "openstack_compute_keypair_v2" "k8s_key" {
  name = "k8s_key"
  public_key = file("./k8s_id_rsa.pub")
}


# Create k8s master node
resource "openstack_compute_instance_v2" "k8s_master" {
  name = "k8s_master"
  image_id = lookup(var.openstack_image_ids, var.openstack_region)
  flavor_id = lookup(var.openstack_flavors, "m1.medium")
  region = var.openstack_region
  security_groups = ["default"]
  key_pair = "k8s_key"
  user_data = "#cloud-config\nhostname: k8s-master\nfqdn: k8s-master"
  network{
    name = openstack_networking_network_v2.k8s_private_net.name
  }
  tags = ["k8s_master"]
    
}
#create worker node 1
resource "openstack_compute_instance_v2" "k8s_node1" {
  name = "k8s_node1"
  image_id = lookup(var.openstack_image_ids, var.openstack_region)
  flavor_id = lookup(var.openstack_flavors, "m1.medium")
  region = var.openstack_region
  security_groups = ["default"]
  key_pair = "k8s_key"
  user_data = "#cloud-config\nhostname: k8s-node1\nfqdn: k8s-node1"
  network{
    name = openstack_networking_network_v2.k8s_private_net.name
  }
  tags = ["k8s_node"]
}
#create worker node 2
resource "openstack_compute_instance_v2" "k8s_node2" {
  name = "k8s_node2"
  image_id = lookup(var.openstack_image_ids, var.openstack_region)
  flavor_id = lookup(var.openstack_flavors, "m1.medium")
  region = var.openstack_region
  security_groups = ["default"]
  key_pair = "k8s_key"
  user_data = "#cloud-config\nhostname: k8s-node2\nfqdn: k8s-node2"
  network{
    name = openstack_networking_network_v2.k8s_private_net.name
  }
  tags = ["k8s_node"]
}
# Associate floating ips
resource "openstack_compute_floatingip_associate_v2" "floatip_1" {
  floating_ip = openstack_networking_floatingip_v2.floatip_1.address
  instance_id = openstack_compute_instance_v2.k8s_master.id
  
}
resource "openstack_compute_floatingip_associate_v2" "floatip_2" {
  floating_ip = openstack_networking_floatingip_v2.floatip_2.address
  instance_id = openstack_compute_instance_v2.k8s_node1.id
}
resource "openstack_compute_floatingip_associate_v2" "floatip_3" {
  floating_ip = openstack_networking_floatingip_v2.floatip_3.address
  instance_id = openstack_compute_instance_v2.k8s_node2.id
}

#resource "null_resource" "test_ansible" {
#  provisioner "local-exec" {
#    command = "ansible -i ${abspath("../ansible/k8s-hosts")} all -m ping"
#    
#  }
#  depends_on = [local_file.k8s_file, 
#                openstack_compute_floatingip_associate_v2.floatip_1,
#                openstack_compute_floatingip_associate_v2.floatip_2,
#                openstack_compute_floatingip_associate_v2.floatip_3]
#}