First, I thinked about putting the magento codes to Docker file, however, it will make the image large size.

Then, what about download the code and mount it as a volume? But you have to download/clone the repo yourself and it's not in an automatic way.

So I make the dockerfile to download the code when creating the container. Code will be clone from github if the mounted folder /var/www/html is empty.

###### Note ######
1. This docker image will have full php extension to start a magento 2 version.
2. You can define the MAGENTO_VERSION variable to get a specific branch from https://github.com/magento/magento2, I have set 2.3-develop as stable for now.
3. I have mounted external folders but you can also modify the docker-compose.yml to mount a volume.
4. This docker file is just for the testing and haven't been optimized yet.
4. I haven't optimized it ( add health check, add redis, ...) because this one is just a testing stage.

####### Instruction #######
1. Change the ENV variable in docker-compose file.
IMPORTANT: If you test on a MAC or Ubuntu desktop, BASE_URL 127.0.0.1 is good enough, however if you run on a server, you should put the server IP instead.
Magento won't work if you set the wrong BASE_URL.
2. Just run command: docker-compose up -d ; and it will start well.
3. Just wipe out the mounted volume/folder to get fresh code again.
