include_recipe 'selenium::default'

directory node['selenium']['server']['installpath']

remote_file File.join(node['selenium']['server']['installpath'], 'selenium-server-standalone.jar') do
  source "http://selenium.googlecode.com/files/selenium-server-standalone-#{node['selenium']['server']['version']}.jar"
  action :create_if_missing
  mode 0644
end

user node['selenium']['server']['user'] do
    home "/home/selenium"
    supports :manage_home => true
    action :create
end

directory node['selenium']['server']['logpath'] do
  owner node['selenium']['server']['user']
  recursive true
end

directory node['selenium']['server']['confpath'] do
  owner node['selenium']['server']['user']
  recursive true
end
