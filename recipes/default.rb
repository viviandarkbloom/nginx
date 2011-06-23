#
# Cookbook Name:: nginx
# Recipe:: default
# Author:: AJ Christensen <aj@junglist.gen.nz>
#
# Copyright 2008-2009, Opscode, Inc.
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

#package "nginx/stable" 

execute "installing specified version" do
	command "apt-get install --assume-yes  nginx/#{node[:nginx][:build]}"
	action :run
	only_if "apt-cache show nginx | grep 'Version: #{node[:nginx][:version]}'"
	end



directory node[:nginx][:log_dir] do
  mode 0755
  owner node[:nginx][:user]
  action :create
end

%w{nxensite nxdissite}.each do |nxscript|
  template "/usr/sbin/#{nxscript}" do
    source "#{nxscript}.erb"
    mode 0755
    owner "root"
    group "root"
  end
end

node[:nginx][:hosts].each do |server|
	template "nginx.conf" do
  		path "#{node[:nginx][:dir]}/nginx.conf"
  		source "nginx.conf.erb"
  		owner "root"
  		group "root"
  		mode 0644
		variables(
			:host => node[:nginx][:hosts]
			)
			action :create
		
	end
	server.each do |name, data|
			directory "/var/log/nginx/#{name[:log]}"
			file "/var/log/nginx/#{name[:log]}/access.log"
			file "/var/log/nginx/#{name[:log]}/error.log"
	end
	
end
#template "#{node[:nginx][:dir]}/sites-available/default" do
#  source "default-site.erb"
#  owner "root"
#  group "root"
#  mode 0644
#end

#service "nginx" do
#  supports :status => true, :restart => true, :reload => true
#  action [ :enable, :start ]
#end
