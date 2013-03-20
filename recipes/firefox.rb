include_recipe "selenium::default"

if "#{node['selenium']['firefox']['version']}" != "last"
  template "/etc/apt/preferences.d/firefox-#{node['selenium']['firefox']['version']}" do
    source "browser-pin.erb"
    mode 0644
    variables ({ :version => "#{node['selenium']['firefox']['version']}", :browser => "firefox" })
  end
end

execute "apt-get update > /dev/null" do
  action :run
end

package "firefox" do
  options "--force-yes"
  action :install
end
