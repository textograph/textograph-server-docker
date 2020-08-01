# Notes
1. Docker image of [textograph server](https://github.com/textograph/textograph-server) (a simple serverside json save and retriever) based on laravel that serves as a json saver for [Textograph web app](https://github.com/textograph/textograph).
2. You can use this repo to containerize your laravel app, just change repo name in `git clone` in Dockerfile
3. Made some changes to `config/database.php` to allow swarm secret files in laravel. it also removes all of the .env entries begining with `DB_` that allows me to define them later using dockers environment variables.
4. When building `Dockerfile`, composer will install your laravel package requirements
5. Added two new env variables (`DB_USERNAME_FILE`,`DB_PASSWORD_FILE`) to forward secret file name to laravel container. especially usefull when you are using swarm.
6. As derived from php-fpm docker it serves php-fastCGI requests in port 8300, you can change it to its default (9000) manually.
7. You must install another webserver like nginx or apache to handle http requests and forward php requests to this container. nginx configuration is presented [here](https://github.com/amsaravi/laravel-docker#nginx-config).
8. The laravel code is hardcoded into the docker image at `/var/www/html` (cloned from your repo). As mounting from container to host is not possible in docker, if you want to change the code, you should do [like this post](https://stackoverflow.com/a/52167722/13304305) as a workaround.
9. As the [textograph-server](https://github.com/textograph/textograph-server) repo adds [Laravel Commando](https://github.com/vkovic/laravel-commando) to its packege requirements I can do many database commands. if you want db commands you must add this package to your `composer.json` file

# Installation

## Dockerize your own laravel app
1. Clone this repo:
```
https://github.com/textograph/textograph-server-docker.git
```
2. Goto to cloned directory: 
```
cd textograph-server-docker
```
3. Edit docker-compose.yml and docker-compose.yml files and change your database settings accordingly. it's better to comment-in `DB_USERNAME_FILE` and `DB_PASSWORD_FILE` entries and use `DB_USERNAME` and `DB_PASSWORD` when you are not using swarm. otherwise you must deal with fake_secret files for developement purpose. change the `Dockerfile` and replace git address of your own repo. uncomment line that installs laravel caommando if you wish.

4. if the database is not exist and database_user (defined in compose file) has correct previllages you can create and migrate databases:
```
docker-compose run laravelsrv php artisan db:create
docker-compose run laravelsrv php artisan migrate
```
! note: You must install [Laravel Commando](https://github.com/vkovic/laravel-commando) to be able to create databases. in textograph-server it is already included.

5. Run the application using docker-compose:
```
docker-compose up
```

## Developement Server
Just for testing and developement purpose you can use php artisan ability to run a minimal web server:
```
docker-compose run -p 8000:8000 laravelsrv php artisan serve  --host 0.0.0.0
```
you can also mount html folder of docker container into host by using `docker-compose.dev.yml` file:
```
docker-compose -f docker-compose.yml -f docker-compose.override.yml -f docker-compose.dev.yml up
``` 
after doing so the containers data will be copied to host and does not go away when you remove the container. as this docker changes the `config/database.php` file you should not commit this change to your repo or simply comment-in the lines that applies git patch in Dockerfile.

## Run with Docker Stack
First create a docker stack file from docker compose files and then run it with docker stack. the final configuration that is added to docker compose files to be able to run in swarm mode is saved in `stack-dev.yml` file.
Use these commands for short:
```
docker-compose -f docker-compose.yml -f docker-compose.override.yml -f stack-dev.yml config > stack-textograph.yml
docker stack deploy -c stack-textograph.yml textograph
```

# Contribution
You can help to make this repo better by doing one of these:
1. Proof reading and rewirting this readme file
2. Do some code to
	- Automatize in-host files access, like what we see in nextcloud-docker
	- Optimize code to work with databases other than mysql
	- do whatever you want
	- comment on this repo and lets me know how it could be better
