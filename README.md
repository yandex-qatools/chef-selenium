One host for hub and node
```
$ cat <<EOF>>recipe.json
{
  "selenium": {
    "server": {
      "version": "2.31.0"
    },
    "chromedriver": {
      "version": "26.0.1383.0"
    },
    "firefox": {
      "version": "last"
    },
    "chrome": {
      "version": "last"
    },
    "opera": {
      "version": "last"
    },
    "hub": {
      "host": "192.168.123.1"
    }  
  },
  "run_list": [
    "recipe[selenium::firefox]",
    "recipe[selenium::opera]",
    "recipe[selenium::chrome]",
    "recipe[selenium::node]",
    "recipe[selenium::hub]"
  ]
}
EOF
```

```
$ echo "deb http://apt.opscode.com/ precise-0.10 main" > /etc/apt/sources.list.d/opscode.list
$ apt-get update > /dev/null; apt-get install chef
```

```
$ mkdir cookbooks && cd cookbooks
$ git clone git://github.com/d3rp/chef-selenium.git selenium
$ cd ../ && tar czvf chef-solo.tar.gz ./cookbooks
```

```
$ chef-solo -j recipe.json -r chef-solo.tar.gz
```

```
$ start selenium-hub
$ start selenium-node
```
