package 'openjdk-7-jre-headless'
package 'unzip'

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
