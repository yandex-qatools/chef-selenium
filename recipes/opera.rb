include_recipe "selenium::default"

package "opera" do
  options "--force-yes"
  action :install
end
