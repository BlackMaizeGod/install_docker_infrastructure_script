# Installation script for [Docker Infrastructure](https://github.com/BlackMaizeGod/docker_infrastructure)

### Notices:
 - After installation go to `/var/www` and run `docker-compose up -d --build` for building infrastructure
 - Magento coding standards project was pulled. For deploying it go to `/var/www/html/magento-coding-standard`,
   use `BASH` alias for enter inside container and run `composer install`.
 - `google-drive-ocamlfuse` was installed. You can configure it in 3 simple steps:
   run `google-drive-ocamlfuse` from terminal and login, then run `mkdir /safe`,
   finally `google-drive-ocamlfuse /safe`
 - PhpMyAdmin available on http://phpmyadmin.local/
 - MailHog available on http://mailhog:8025/
 - Elasticsearch available on http://elasticsearch7:9200/
 - To check the Redis use: `redis-cli -h $(getContainerAddress redis) -p 6379 -a <password>`
 - To check the Memcached use: `echo stats | nc $(getContainerAddress memcached) 11211`

### Recommend to Install:
 - Firefox (preinstalled / need to configure)
 - Guake (preinstalled / need to configure)
 - Google Drive Mounter `google-drive-ocamlfuse` (preinstalled / need to configure)
 - Diodon
 - Flameshot
 - GNOME Tweaks
 - PhpStorm (need to configure)
 - Sublime Text (need to configure)
 - Postman
 - Slack
 - Telegram
 - GNU Image Manipulation Program
 - KeePassXC
 - Kazam
 - VirtualBox
 - GParted
 - Grub Customizer
 - Htop

### Aliases:
 - `MY56` - connect to mysql 5.6 cli inside docker container
 - `MY57` - connect to mysql 5.7 cli inside docker container
 - `MY80` - connect to mysql 8.0 cli inside docker container
 - `MY101` - connect to maria_db 10.1 cli inside docker container
 - `MY102` - connect to maria_db 10.2 cli inside docker container
 - `MY103` - connect to maria_db 10.3 cli inside docker container
 - `MY104` - connect to maria_db 10.4 cli inside docker container
 - `RNG` - restart nginx container, may be useful after adding new host for project
 - `BASH` - run from project folder root. Connect to shell inside php-fpm container, which serves the project 
 - `BASHR` - the same as upper alias but cli user is root
 - `CR` - remove cache and static files directories
