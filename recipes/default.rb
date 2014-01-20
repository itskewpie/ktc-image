#
# Cookbook Name:: ktc-image
# Recipe:: default
#
# Copyright 2013, KT Cloudware
#
# All rights reserved - Do Not Redistribute
#

include_recipe "services"
include_recipe "ktc-utils"

iface = KTC::Network.if_lookup "management"
ip = KTC::Network.address "management"

Services::Connection.new run_context: run_context
image_api = Services::Member.new node["fqdn"],
  service: "image-api",
  port: 9292,
  proto: "tcp",
  ip: ip

image_api.save

image_registry = Services::Member.new node["fqdn"],
  service: "image-registry",
  port: 9191,
  proto: "tcp",
  ip: ip

image_registry.save

KTC::Attributes.set

node.default["openstack"]["image"]["api"]["bind_interface"] = iface
node.default["openstack"]["image"]["registry"]["bind_interface"] = iface

include_recipe "openstack-common"
include_recipe "openstack-common::logging"
include_recipe "ktc-image::package_setup"
include_recipe "openstack-image::registry"
include_recipe "openstack-image::api"
include_recipe "openstack-image::identity_registration"

# process monitoring and sensu-check config
processes = node['openstack']['image']['api_processes']

processes.each do |process|
  sensu_check "check_process_#{process['name']}" do
    command "check-procs.rb -c 10 -w 10 -C 1 -W 1 -p #{process['name']}"
    handlers ["default"]
    standalone true
    interval 30
  end
end

ktc_collectd_processes "image-processes" do
  input processes
end
