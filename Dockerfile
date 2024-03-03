# Use an official PHP image as the base image
FROM php:latest

# Install required dependencies
RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    autoconf \
    && git clone --recursive --depth=1 https://github.com/kjdev/php-ext-lz4.git /tmp/php-ext-lz4

# Install LZ4 extension
RUN cd /tmp/php-ext-lz4 && phpize && ./configure && make && make install

# Enable LZ4 extension
RUN echo "extension=lz4.so" > /usr/local/etc/php/conf.d/lz4.ini

# Clean up
RUN rm -rf /tmp/php-ext-lz4

# Clone Thanos repository
RUN git clone https://github.com/Bartixxx32/thanos /thanos

# Set the working directory
WORKDIR /thanos

# Install Composer
RUN apt-get install -y zip unzip
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Thanos using Composer
RUN composer install

# Set the entry point for the CLI tool
ENTRYPOINT [ "php", "./thanos.php" ]
