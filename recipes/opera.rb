include_recipe "selenium::default"

repository="deb http://deb.opera.com/opera/ stable non-free"
file "/etc/apt/sources.list.d/opera.list" do
  owner "root"
  group "root"
  mode "0644"
  content repository
  action :create_if_missing
end

if "#{node['selenium']['opera']['version']}" != "last"
  template "/etc/apt/preferences.d/opera-#{node['selenium']['opera']['version']}" do
    source "browser-pin.erb"
    mode 0644
    variables ({ :browser => "opera", :version => "#{node['selenium']['opera']['version']}" })
  end
end

execute "apt-get update > /dev/null" do
  action :run
end

package "opera" do
  options "--force-yes"
  action :install
end
