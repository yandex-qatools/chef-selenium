include_recipe "selenium::server"
package "xvfb"

cookbook_file "/usr/local/bin/node-config.sh" do
  source "node-config.sh"
  owner "root"
  mode "0755"
end

execute "/usr/local/bin/node-config.sh #{File.join(node['selenium']['server']['confpath'], 'node.json')}" do
  action :run
end

template "/etc/init/selenium-node.conf" do
  source "node.erb"
  mode 0644
  variables ({
    :fbsize => "#{node['selenium']['xvfb']['fbsize']}",
    :xmx => "#{node['selenium']['node']['memory']}",
    :chromedriver => File.join(node['selenium']['chromedriver']['installpath'], 'chromedriver'),
    :config => File.join(node['selenium']['server']['confpath'], 'node.json'),
    :selenium => File.join(node['selenium']['server']['installpath'], 'selenium-server-standalone.jar'),
    :host => "#{node['selenium']['hub']['host']}",
    :port => "#{node['selenium']['hub']['port']}",
    :log => File.join(node['selenium']['server']['logpath'], 'node.log')})
end

service "selenium-node" do
  provider Chef::Provider::Service::Upstart
  supports :restart => true, :start => true, :stop => true
  action [:enable, :start]
end
