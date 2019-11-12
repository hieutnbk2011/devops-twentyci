#!/bin/bash

verify_user(){
	#check if the user running as root
  if [[ $EUID -ne 0 ]]
  then 
    >&2 echo "Please running script by user root or use sudo"
    exit 1
  fi
}

install_components(){
## Add repo
  echo -n "(1/8)Modify repositories."
  apt update > /dev/null
  apt install -y curl wget gnupg2 ca-certificates lsb-release apt-transport-https &> /dev/null
  apt-get install -y language-pack-en-base &> /dev/null
  locale-gen en_US.UTF-8 > /dev/null
  export LANG=en_US.UTF-8 
  export LC_ALL=en_US.UTF-8
  apt-add-repository -y ppa:ondrej/php > /dev/null
  apt update > /dev/null
  echo Done.
## Install php
## JSON, OpenSSL, PDO, Ctype and Tokenizer should have been added by default in php 7.1 
  echo -n "(2/8)Install PHP and extension."
  apt install -y php7.1-fpm php7.1-cli php7.1-common php7.1-bcmath php7.1-mbstring php7.1-xml &> /dev/null
  echo Done.
## Install git
  echo -n "(3/8)Install Git."
  apt install git
  echo Done.
## Install composer 
  echo -n "(4/8)Install Composer."
  cd ~
  curl -sS https://getcomposer.org/installer -o composer-setup.php 
  HASH=$(curl -s https://composer.github.io/pubkeys.html | grep '<pre>' | sed -e 's/<[^>]*>//g') 
  if [[ "$(sha384sum composer-setup.php | cut -d' ' -f1)" == "$HASH" ]]
  then
    echo Installer verifed.
  else 
    echo Installer corrupted.
    return 1
  fi 
  php composer-setup.php --install-dir=/usr/local/bin --filename=composer > /dev/null
  rm -f composer-setup.php
  echo Done.
## Install PHP
  echo -n "(5/8)Install MySQL database."
  apt install -y mysql-server-5.7 &> /dev/null
  echo Done.
## Install nginx
  echo -n  "(6/8)Install nginx."
  apt install -y nginx &> /dev/null
  ufw allow 'Nginx HTTP' > /dev/null
  echo Done.
}

configure_nginx(){
  echo -n  "(7/8)Creating index.php."
mkdir -p /var/www/
  cat << EOF > /var/www/index.php
<?php
echo  'Hello  World!';
EOF

  cat << EOF > /etc/nginx/sites-available/default
server {
        listen 80 default_server;
        listen [::]:80 default_server;
        root /var/www/;
        index index.php;
        server_name localhost devopstest.com www.devopstest.com;
        location / {
                try_files \$uri \$uri/ =404;
        }
    	location ~ \\.php\$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php7.1-fpm.sock;
   	 }
    	location ~ /\\.ht {
        deny all;
   	 }
}	
EOF
echo Done.
echo  -n  '(8/8)Restart Service.'
service php7.1-fpm start
service nginx restart
echo Done.
  
}
main() {
   verify_user
   install_components
   configure_nginx
   echo "You should be able to access the website at one of urls below:"
   echo '    -http://localhost'
   listip="$(ifconfig | grep enp -A1 | awk '/inet / {print $2}')"
   for  ip in $listip
   do
     echo '    -http://'$ip
   done

}

main $*
