include_recipe "selenium::default"

directory node['selenium']['phantomjs']['installpath']
                                                                              i
execute "unpack phantomjs" do
  command "tar xj -C #{node['selenium']['phantomjs']['installpath']} /tmp/phantomjs-#{node['selenium']['phantomjs']['version']}-linux-x86_64.tar.bz2"
  action :nothing
end

remote_file "/tmp/phantomjs-#{node['selenium']['phantomjs']['version']}-linux-x86_64.tar.bz2" do
  source "https://phantomjs.googlecode.com/files/phantomjs-#{node['selenium']['phantomjs']['version']}-linux-x86_64.tar.bz2"
  action :create_if_missing
  notifies :run, "execute[unpack phantomjs]", :immediately
  modo 755
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

service "ghostdriver" do
  provider Chef::Provider::Service::Upstart
  supports :restart => true, :start => true, :stop => true
  action [:enable, :start]
end
