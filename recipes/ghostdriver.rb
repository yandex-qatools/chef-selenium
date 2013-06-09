include_recipe "selenium::default"

directory node['selenium']['phantomjs']['installpath']

execute "move phantomjs" do
  command "mv /tmp/phantomjs-#{node['selenium']['phantomjs']['version']}-linux-x86_64/bin/phantomjs #{node['selenium']['phantomjs']['installpath']}"
  action :nothing
end

execute "unpack phantomjs" do
  command "tar xjf /tmp/phantomjs-#{node['selenium']['phantomjs']['version']}-linux-x86_64.tar.bz2 -C /tmp"
  action :nothing
  notifies :run, "execute[move phantomjs]", :immediately
end

remote_file "/tmp/phantomjs-#{node['selenium']['phantomjs']['version']}-linux-x86_64.tar.bz2" do
  source "https://phantomjs.googlecode.com/files/phantomjs-#{node['selenium']['phantomjs']['version']}-linux-x86_64.tar.bz2"
  action :create
  notifies :run, "execute[unpack phantomjs]", :immediately
end

template "/etc/init/selenium-ghostdriver.conf" do
  source "ghostdriver.erb"
  mode 0644
  variables ({
    :phantomjs => File.join(node['selenium']['phantomjs']['installpath'], 'phantomjs'),
    :gdport => "#{node['selenium']['ghostdriver']['port']}",
    :host => "#{node['selenium']['hub']['host']}",
    :port => "#{node['selenium']['hub']['port']}",
    :log => File.join(node['selenium']['server']['logpath'], 'ghostdriver.log')})
end

service "selenium-ghostdriver" do
  provider Chef::Provider::Service::Upstart
  supports :restart => true, :start => true, :stop => true
  action [:enable, :start]
end
