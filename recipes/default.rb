#
# Cookbook Name:: ktc-image
# Recipe:: default
#
# Copyright 2013, KT Cloudware
#
# All rights reserved - Do Not Redistribute
#

class Chef::Recipe
  include KTCUtils
end

d1 = get_openstack_service_template(get_interface_address("management"), "9292")
register_service("image-api", d1)

d2 = get_openstack_service_template(get_interface_address("management"), "9191")
register_service("image-registry", d2)

set_rabbit_servers "image-api"
set_database_servers "image"
set_service_endpoint_ip "image-api"
set_service_endpoint_ip "image-registry"
node.default["openstack"]["image"]["api"]["bind_interface"] = get_interface "management"
node.default["openstack"]["image"]["registry"]["bind_interface"] = get_interface "management"

include_recipe "openstack-common"
include_recipe "openstack-common::logging"
include_recipe "openstack-image::api"
include_recipe "openstack-image::registry"
include_recipe "openstack-image::identity_registration"

