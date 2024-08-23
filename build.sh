#!/bin/sh
export DEBIAN_FRONTEND=noninteractive
export TARGETARCH=$(/usr/bin/dpkg --print-architecture)

apt-get update -q 
apt-get install -y --no-install-recommends wget curl certbot pwgen 
echo "---> INSTALLING s6-overlay" 

wget https://github.com/just-containers/s6-overlay/releases/download/v1.22.1.0/s6-overlay-$ARCH.tar.gz 
tar xzf s6-overlay-$ARCH.tar.gz -C / 
rm s6-overlay-$ARCH.tar.gz 
echo "---> INSTALLING envplate" 

if [ "$TARGETARCH" -eq "amd64" ]; then export ARCH="x_86_64"; else export ARCH="arm64"; fi 


echo "downloading: https://github.com/kreuzwerker/envplate/releases/download/v1.0.2/envplate_1.0.2_Linux_$ARCH.tar.gz "



curl -L  -o envplate.tar.gz https://github.com/kreuzwerker/envplate/releases/download/v1.0.3/envplate_1.0.3_Linux_$ARCH.tar.gz 
tar -zxvf envplate.tar.gz 
rm envplate.tar.gz 
find . -name envplate -exec mv {} /usr/local/bin/ep \; 
chmod a+x /usr/local/bin/ep 



echo "---> Creating directories"  
mkdir -p /etc/services.d/nginx /etc/services.d/certbot  
echo "---> Cleaning up"  
apt-get remove -y wget  
rm -Rf /var/lib/apt /var/cache/apt  
touch /etc/nginx/auth_part1.conf \
            /etc/nginx/auth_part2.conf \
            /etc/nginx/request_size.conf \
            /etc/nginx/main_location.conf \
            /etc/nginx/trusted_proxies.conf \
            /tmp/htpasswd