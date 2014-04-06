#
# Cookbook Name:: thumbor
# Recipe:: experimental
#
# Copyright 2013, Enrico Baioni <enrico.baioni@zanui.com.au>
# Copyright 2013, Zanui <engineering@zanui.com.au>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'git'
include_recipe 'python'
include_recipe 'build-essential'

app_user = node['thumbor']['user']
app_group = node['thumbor']['group']
virtualenv = node['thumbor']['virtualenv']
paths = [
          node['thumbor']['options']['FILE_STORAGE_ROOT_PATH'],
          node['thumbor']['options']['RESULT_STORAGE_FILE_STORAGE_ROOT_PATH']
        ]

required_packages = %w(libjpeg-dev libpng-dev libtiff-dev libjasper-dev libgtk2.0-dev python-numpy python-pycurl  webp libwebp-dev python-opencv libcurl4-gnutls-dev)

required_packages.each do |pkg|
  package pkg
end

group app_group do
  action :create
end

user app_user do
  gid app_group
  action :create
end

paths.each do |path|
  directory path do
    action :create
    recursive true
    owner app_user
    group app_group
    mode '0755'
  end
end

python_virtualenv virtualenv do
  interpreter 'python2.7'
  owner app_user
  group app_group
  action :create
end

python_pip 'git+git://github.com/globocom/thumbor.git' do
  action :install
  virtualenv virtualenv
  notifies :restart, 'service[thumbor]'
end

template '/etc/init/thumbor.conf' do
  source 'thumbor.ubuntu.upstart.erb'
  owner  'root'
  group  'root'
  mode   '0755'
end

template '/etc/init/thumbor-worker.conf' do
  source 'thumbor.worker.erb'
  owner  'root'
  group  'root'
  mode   '0755'
end

template '/etc/default/thumbor' do
  source 'thumbor.default.erb'
  owner  'root'
  group  'root'
  mode   '0644'
  notifies :restart, 'service[thumbor]'
  variables({
    :instances => node['thumbor']['processes'],
    :base_port => node['thumbor']['base_port']
  })
end

template '/etc/thumbor.conf' do
  source 'thumbor.conf.default.erb'
  owner  app_user
  group  app_group
  mode   '0644'
  notifies :restart, 'service[thumbor]'
  variables({
    :options    => node['thumbor']['options']
  })
end

file '/etc/thumbor.key' do
  content node['thumbor']['key']
  owner  app_user
  group  app_group
  mode   '0644'
  notifies :restart, 'service[thumbor]'
end

service 'thumbor' do
  provider Chef::Provider::Service::Upstart
  supports :restart => true, :start => true, :stop => true, :reload => true
  action   [:enable, :start]
end
