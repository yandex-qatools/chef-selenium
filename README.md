One host for hub and node
```
$ cat <<EOF>>recipe.json
{
  "selenium": {
    "server": {
      "version": "2.33.0"
    },
    "chromedriver": {
      "version": "2.0"
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
      "host": "127.0.0.1"
    }
  },
  "run_list": [
    "recipe[selenium::firefox]",
    "recipe[selenium::opera]",
    "recipe[selenium::chrome]",
    "recipe[selenium::node]",
    "recipe[selenium::ghostdriver]",
    "recipe[selenium::hub]"
  ]
}
EOF
```

```
$ echo "deb http://apt.opscode.com/ precise-0.10 main" > /etc/apt/sources.list.d/opscode.list
$ apt-get update > /dev/null; apt-get install chef git-core
```

```
$ mkdir cookbooks && cd cookbooks
$ git clone git://github.com/d3rp/chef-selenium.git selenium
$ cd ../ && tar czvf chef-solo.tar.gz ./cookbooks
```

```
$ chef-solo -j recipe.json -r chef-solo.tar.gz
```
