include_recipe "selenium::server"

template "/etc/init/selenium-hub.conf" do
  source "hub.erb"
  mode 0644
  variables ({
    :xmx => "#{node['selenium']['hub']['memory']}",
    :selenium => File.join(node['selenium']['server']['installpath'], 'selenium-server-standalone.jar'),
    :port => "#{node['selenium']['hub']['port']}",
    :options => "#{node['selenium']['hub']['options']}",
    :log => File.join(node['selenium']['server']['logpath'], 'hub.log')})
end

service "selenium-hub" do
  provider Chef::Provider::Service::Upstart
  supports :restart => true, :start => true, :stop => true
  action [:enable, :start]
end
