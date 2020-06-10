FROM amsaravi/laravel:latest as laravel
WORKDIR /var/www/
RUN git clone https://github.com/textograph/textograph-server.git html
ARG user=nginx
USER $user
WORKDIR /var/www/html
RUN composer update

## uncomment to automatically install in your laravel apps
# RUN composer require vkovic/laravel-commando

RUN cp .env.example .env
COPY change_conf.patch .
RUN git apply change_conf.patch
RUN php artisan key:generate
RUN sed -E -i "s/^DB_//g" .env
RUN chown $user ./ -R