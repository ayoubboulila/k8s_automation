variable "openstack_user_name" {}
variable "openstack_tenant_name" {}
variable "openstack_password" {}
variable "openstack_auth_url" {}
variable "openstack_region" {
  default = "RegionOne"
}
variable "openstack_image_ids" {
  type = map(string)
  default = {
    RegionOne = "dbaaf9f8-de4f-4ee9-aa11-6db1d7343403"
    RegionTwo = "87d115c1-6ec8-493b-92b5-c523a655752b"
  }
}

variable "k8s_node" {
  type = map(string)
  default = {

  }
}
variable "openstack_external_network_id" {
  default = "e20e09af-5e74-461d-970c-ca0167cf922e"
}
variable "openstack_flavors" {
  type = map(string)
  default = {
    "m1.small" = "2"
    "m1.medium" = "3"
  }
}