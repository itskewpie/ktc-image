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

