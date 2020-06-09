FROM amsaravi/laravel:latest as laravel
WORKDIR /var/www/
RUN git clone https://github.com/textograph/textograph-server.git html
USER root
WORKDIR /var/www/html
RUN composer update
ARG user=nginx
RUN cp .env.example .env
COPY change_conf.patch .
RUN git apply change_conf.patch
RUN php artisan key:generate
RUN sed -E -i "s/^DB_//g" .env
RUN chown $user ./ -R