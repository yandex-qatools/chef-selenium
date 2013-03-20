#!/bin/bash

dst=${1:-"/etc/selenium/node.json"}
browsers="firefox chromium-browser opera google-chrome-stable"
selenium=0

json_header() {
cat <<EOF> $dst
{
    "capabilities":
        [
EOF
}

json_browser() {
# $1 - browser name, $2 - version, $3 - protocol
cat <<EOF>> $dst
            {
                "browserName": "$1",
                "version": "$2",
                "maxInstances": 5,
                "seleniumProtocol": "$3",
                "platform": "LINUX"
            },
EOF
}

json_footer() {
cat <<EOF>> $dst
        ],
    "configuration":
        {
            "proxy": "org.openqa.grid.selenium.proxy.DefaultRemoteProxy",
            "maxSession": 5,
            "register": true,
            "registerCycle": 5000
        }
}
EOF
}

get_browser_version() {
    # $1 - browser name
    version=$(dpkg -l | grep "ii  $1 " | awk '{print $3}' | awk -F '.' \
        '{print $1"."$2}' | grep -Eo "[0-9]*\.[0-9]*" 2>/dev/null)
    if [ $? -eq 0 ]; then
        echo $version
        return 0
    fi
    return 1
}

# check firefox 3.6
ff_v=$(get_browser_version "firefox")
#echo $ff_v | grep "3.6" > /dev/null 2>&1
#[ $? -eq 0 ] && selenium=1
[ "x$ff_v" == "x3.6" ] && selenium=1

json_header

for browser in $browsers; do
    browser_version=$(get_browser_version $browser)
    if [ $? -eq 0 ]; then
        if [ $selenium -eq 1 ]; then
            case $browser in
                "chromium-browser")
                    json_browser "*googlechrome" $browser_version "Selenium"
                ;;
                "firefox")
                    json_browser "*firefox" $browser_version "Selenium"
                ;;
            esac
        fi
        if [ "x$browser" == "xchromium-browser" -o "x$browser" == "xgoogle-chrome-stable" ]; then
            json_browser "chrome" $browser_version "WebDriver"
        else
            json_browser "$browser" $browser_version "WebDriver"
        fi
    fi
done

json_browser "htmlunit" "firefox" "WebDriver"

json_footer
