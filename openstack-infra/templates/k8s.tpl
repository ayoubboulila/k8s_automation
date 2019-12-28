[kube-master]
${k8s_master_name}

[kube-node]
${k8s_node_name}

[all:vars]
ansible_ssh_private_key_file = ${key_path}
ansible_ssh_user = ubuntu