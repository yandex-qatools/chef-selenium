include_recipe "selenium::default"

repository="deb http://dl.google.com/linux/chrome/deb/ stable main"
file "/etc/apt/sources.list.d/google-chrome-stable.list" do
  owner "root"
  group "root"
  mode "0644"
  content repository
  action :create_if_missing
end

if "#{node['selenium']['chrome']['version']}" != "last"
  template "/etc/apt/preferences.d/chrome-#{node['selenium']['chrome']['version']}" do
    source "browser-pin.erb"
    mode 0644
    variables ({ :browser => "google-chrome-stable", :version => "#{node['selenium']['chrome']['version']}" })
  end
end

execute "apt-get update > /dev/null" do
  action :run
end

package "google-chrome-stable" do
  options "--force-yes"
  action :install
end

execute "unpack chromedriver" do
  command "unzip -o /tmp/chromedriver_linux64_#{node['selenium']['chromedriver']['version']}.zip -d #{node['selenium']['chromedriver']['installpath']}"
  action :nothing
end

remote_file "/tmp/chromedriver_linux64_#{node['selenium']['chromedriver']['version']}.zip" do
  source "http://chromedriver.googlecode.com/files/chromedriver_linux64_#{node['selenium']['chromedriver']['version']}.zip"
  action :create_if_missing
  notifies :run, "execute[unpack chromedriver]", :immediately
end

file File.join(node['selenium']['chromedriver']['installpath'], 'chromedriver') do
  mode 0755
  owner 'root'
  group 'root'
end
