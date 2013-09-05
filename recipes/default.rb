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

iface = get_interface_address("management")
d1 = get_openstack_service_template(iface, "9292")
register_member("image-api", d1)

d2 = get_openstack_service_template(iface, "9191")
register_member("image-registry", d2)

# dependant services
set_rabbit_servers "image-api"
set_database_servers "image"
set_service_endpoint "identity-api"
set_service_endpoint "identity-admin"
set_service_endpoint "image-registry"
set_service_endpoint "image-api"

node.default["openstack"]["image"]["api"]["bind_interface"] = iface
node.default["openstack"]["image"]["registry"]["bind_interface"] = iface

include_recipe "openstack-common"
include_recipe "openstack-common::logging"
include_recipe "openstack-image::registry"
include_recipe "openstack-image::api"
include_recipe "openstack-image::identity_registration"
