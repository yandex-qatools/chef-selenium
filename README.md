One host for hub and node

Installing via chef-solo:

echo "chef chef/chef_server_url string localhost 
      postfix postfix/root_address string
      postfix postfix/rfc1035_violation boolean false 
      postfix postfix/retry_upgrade_warning boolean 
      postfix postfix/kernel_version_warning boolean 
      postfix postfix/mydomain_warning boolean 
      postfix postfix/mynetworks string 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128 
      postfix postfix/sqlite_warning boolean 
      postfix postfix/relayhost string
      postfix postfix/mailbox_limit string 0 
      postfix postfix/procmail boolean false 
      postfix postfix/bad_recipient_delimiter error
      postfix postfix/protocols select
      postfix postfix/mailname string devfol.qa.yandex.net 
      postfix postfix/tlsmgr_upgrade_warning boolean 
      postfix postfix/recipient_delim string
      postfix postfix/main_mailer_type select No configuration 
      postfix postfix/destinations string devfol.qa.yandex.net, localhost.qa.yandex.net, , localhost 
      postfix postfix/chattr boolean false" | debconf-set-selections

echo "deb http://apt.opscode.com/ precise-0.10 main" > /etc/apt/sources.list.d/opscode.list

apt-get update > /dev/null; apt-get install chef git-core

mkdir cookbooks && cd cookbooks

git clone git://github.yandex-team.ru/urtow/selenium.git

mv selenium/recipe.json ../

cd ../ && tar czvf chef-solo.tar.gz ./cookbooks

chef-solo -j recipe.json -r chef-solo.tar.gz
