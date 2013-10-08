One host for hub and node

Installing via chef-solo:

echo "chef chef/chef_server_url string localhost 
      
      postfix postfix/main_mailer_type select No configuration " | debconf-set-selections

echo "deb http://apt.opscode.com/ precise-0.10 main" > /etc/apt/sources.list.d/opscode.list

apt-get update > /dev/null; apt-get install chef git-core

mkdir cookbooks && cd cookbooks

git clone git://github.com/yandex-qatools/chef-selenium.git selenium

mv selenium/recipe.json ../

cd ../ && tar czvf chef-solo.tar.gz ./cookbooks

chef-solo -j recipe.json -r chef-solo.tar.gz
