# official Docker Library Drupal image == means we don’t need to do the work of setting up Apache and PHP
FROM drupal:8.4-apache

# installing some tools we need inside the image for the next steps. 
# mysql-client seems like a weird choice but Drush won’t connect properly to our site’s database without it
# we create the command like this with a multi-line, single RUN step as it improves Docker layer caching
RUN apt-get update && apt-get install -y \
    curl \
    git \
    mysql-client \
    vim \
    wget

# install Composer, the PHP dependency manager. Everything that’s not already installed by you or the Docker image will be handled by Composer.
# NOTE: Composer is installed for the root user. You’ll see a warning over and over that you shouldn’t use the root user with Composer. 
# We’re working in a Docker image where the only regular user is the root user.
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php && \
    mv composer.phar /usr/local/bin/composer && \
    php -r "unlink('composer-setup.php');"

# installing Drush Launcher. Makes using Drush on the command-line easier now that it’s no longer recommended to install Drush globally.
RUN wget -O drush.phar https://github.com/drush-ops/drush-launcher/releases/download/0.4.2/drush.phar && \
    chmod +x drush.phar && \
    mv drush.phar /usr/local/bin/drush

# deletes the copy of Drupal that ships with the Docker image
RUN rm -rf /var/www/html/*

# copy over the custom Apache VirtualHost configuration file to tell Apache where we want to host our website within the filesystem.
COPY apache-drupal.conf /etc/apache2/sites-enabled/000-default.conf

WORKDIR /app
