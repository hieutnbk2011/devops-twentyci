FROM ubuntu:18.04
MAINTAINER hieu.tnbk2011@yahoo.com
WORKDIR /root/
# Set Environment
ENV BASE_URL=127.0.0.1
ENV DB_HOST=mariadb
ENV DB_NAME=magento
ENV DB_USER=magento
ENV DB_PASSWORD=magento
ENV MAGENTO_VERSION=2.3-develop
ENV ADMIN_PASSWORD=admin123
# Install Packages
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates curl nano mysql-client git 
RUN export LANG=en_US.UTF-8 \ 
    && apt-get install -y software-properties-common \
    && apt-get install -y language-pack-en-base \
    && LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php \
    && apt-get update 
RUN  apt-get -y install php7.2 php7.2-pdo php7.2-mysqlnd php7.2-opcache php7.2-xml php7.2-gd php7.2-mysql php7.2-curl php7.2-zip php7.2-intl php7.2-mbstring php7.2-bcmath php7.2-json php7.2-iconv php7.2-soap 
# Config Apache & PHP
RUN sed -i -e"s/^memory_limit\s*=\s*128M/memory_limit = 2048M/" /etc/php/7.2/apache2/php.ini \
    && sed -i -e"s/^;opcache.enable=1/opcache.enable=1/" /etc/php/7.2/apache2/php.ini \ 
    && a2enmod rewrite \
    && a2enmod headers \
    && rm -rf /var/www/html/* \
    && sed -i "s/None/all/g" /etc/apache2/apache2.conf 
# Install composer
RUN curl -sS https://getcomposer.org/installer -o composer-setup.php \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \ 
    && rm -f composer-setup.php
COPY entry.sh /usr/local/bin/
ENTRYPOINT ["/bin/sh","/usr/local/bin/entry.sh"]
CMD ["/usr/sbin/apache2ctl","-DFOREGROUND"]
