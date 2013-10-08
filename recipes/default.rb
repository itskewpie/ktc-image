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
image_api = Services::Member.new node.default.fqdn,
  service: "image-api",
  port: 9292,
  proto: "tcp",
  ip: ip

image_api.save
KTC::Network.add_service_nat "image-api", 9292

image_registry = Services::Member.new node.default.fqdn,
  service: "image-registry",
  port: 9191,
  proto: "tcp",
  ip: ip

image_registry.save
KTC::Network.add_service_nat "image-registry", 9191

KTC::Attributes.set

node.default["openstack"]["image"]["api"]["bind_interface"] = iface
node.default["openstack"]["image"]["registry"]["bind_interface"] = iface

include_recipe "openstack-common"
include_recipe "openstack-common::logging"
include_recipe "openstack-image::registry"
include_recipe "openstack-image::api"
include_recipe "openstack-image::identity_registration"
