#!/bin/bash
set -e
if [ ! -d "/var/www/html/magento2" ]; then
    cd /var/www/html/
    git clone -b "${MAGENTO_VERSION}" https://github.com/magento/magento2.git
    cd magento2
    composer install
    php bin/magento setup:install --base-url=http://${BASE_URL}/magento2/ --db-host=${DB_HOST} --db-name=${DB_NAME} --db-user=${DB_USER} --db-password=${DB_PASSWORD} --admin-firstname=Magento --admin-lastname=User --admin-email=user@example.com --admin-user=admin --admin-password=${ADMIN_PASSWORD} --language=en_US --currency=USD --timezone=America/Chicago --use-rewrites=1 --backend-frontname="admin"
    chown -R www-data.www-data /var/www/html/magento2/
    fi
exec "$@"

