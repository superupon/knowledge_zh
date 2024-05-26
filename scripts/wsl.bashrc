# proxy settings
local_ip=`ip route | awk '/^default via / {print $3}'`
export http_proxy=http://$local_ip:7897
export https_proxy=http://$local_ip:7897
echo "http proxy: " $http_proxy
git config --global http.proxy $http_proxy
git config --global https.proxy $http_proxy
