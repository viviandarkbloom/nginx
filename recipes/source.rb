nginx_version = node[:nginx][:version]

node.set[:nginx][:install_path]    = "/opt/nginx-#{nginx_version}"
node.set[:nginx][:src_binary]      = "#{node[:nginx][:install_path]}/sbin/nginx"
node.set[:nginx][:daemon_disable]  = true
node.set[:nginx][:configure_flags] = [
  "--prefix=#{node[:nginx][:install_path]}",
  "--conf-path=#{node[:nginx][:dir]}/nginx.conf",
  "--with-http_ssl_module",
  "--with-http_gzip_static_module"
]

configure_flags = node[:nginx][:configure_flags].join(" ")

bash "installing nginx" do
        user "root"
        cwd "/tmp"
        code <<-CMD
			wget http://sysoev.ru/nginx/nginx-"#{nginx_version}".tar.gz 
			tar zxf nginx-#{nginx_version}.tar.gz
    		cd nginx-#{nginx_version} && ./configure #{configure_flags}
    		make && make install
		CMD
end


