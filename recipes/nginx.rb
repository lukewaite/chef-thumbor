#
# Cookbook Name:: thumbor
# Recipe:: nginx
#
# Copyright 2013, Enrico Stahn <mail@enricostahn.com>
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

include_recipe 'nginx'

template '/etc/nginx/conf.d/thumbor.conf' do
  source 'nginx.conf.erb'
  owner  'root'
  group  'root'
  mode   '0644'
  notifies :restart, 'service[nginx]'
  variables({
                :instances            => node['thumbor']['processes'],
                :base_port            => node['thumbor']['base_port'],
                :server_port          => node['thumbor']['nginx']['port'],
                :server_name          => node['thumbor']['nginx']['server_name'],
                :proxy_cache_enabled  => node['thumbor']['nginx']['proxy_cache']['enabled'],
                :proxy_cache_path     => node['thumbor']['nginx']['proxy_cache']['path'],
                :proxy_cache_key_zone => node['thumbor']['nginx']['proxy_cache']['key_zone']
            })
end

