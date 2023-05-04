# Use a specific version of PHP
FROM php:8.0-fpm

# Install required dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    libzip-dev \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set the working directory
WORKDIR /var/www/html

# Copy the Laravel project files
COPY . /var/www/html

# Install project dependencies
RUN composer install --optimize-autoloader --no-dev --no-interaction
RUN php artisan key:generate

# Set permissions for storage and cache directories
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Copy the PHP configuration file with updated timezone setting
COPY php.ini /usr/local/etc/php/conf.d/

# Update the entrypoint command to run the Laravel application using PHP's built-in web server
CMD php artisan serve --host=0.0.0.0 --port=8000

# Expose port 8000 for the web server
EXPOSE 8000
