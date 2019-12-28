data "template_file" "k8s"{
 template = file("./templates/k8s.tpl")
  vars = {
    k8s_master_name = join("\n", [openstack_networking_floatingip_v2.floatip_1.address])
    k8s_node_name = join("\n", [openstack_networking_floatingip_v2.floatip_2.address, 
                                openstack_networking_floatingip_v2.floatip_3.address])
    key_path = abspath("./k8s_id_rsa")

  }
}

resource "local_file" "k8s_file" {
  content = data.template_file.k8s.rendered
  filename = "../ansible-k8s/k8s-hosts"
}

