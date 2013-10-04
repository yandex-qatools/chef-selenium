include_recipe "selenium::default"

repository="deb http://dl.google.com/linux/chrome/deb/ stable main"
file "/etc/apt/sources.list.d/google-chrome-stable.list" do
  owner "root"
  group "root"
  mode "0644"
  content repository
  action :create_if_missing
end

repository="deb http://deb.opera.com/opera/ stable non-free"
file "/etc/apt/sources.list.d/opera.list" do
  owner "root"
  group "root"
  mode "0644"
  content repository
  action :create_if_missing
end


execute "apt-get update > /dev/null" do
  action :run
end

