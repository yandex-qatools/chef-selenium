include_recipe "selenium::default"

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
  action :create
  notifies :run, "execute[unpack chromedriver]", :immediately
end

file File.join(node['selenium']['chromedriver']['installpath'], 'chromedriver') do
  mode 0755
  owner 'root'
  group 'root'
end
