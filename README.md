# Installation script for [Docker Infrastructure](https://github.com/BlackMaizeGod/docker_infrastructure)

### Notices:
 - After installation go to `/var/www` and run `docker-compose up -d --build` for building infrastructure
 - `google-drive-ocamlfuse` was installed. You can configure it in 3 simple steps:
   run `google-drive-ocamlfuse` from terminal and login, then run `mkdir /safe`,
   finally `google-drive-ocamlfuse /safe`
 - PhpMyAdmin available on http://phpmyadmin.local/
 - MailHog available on http://mailhog:8025/
 - Elasticsearch available on http://elasticsearch7:9200/
 - RabbitMQ available on http://rabbitmq:15672/
 - To check the Redis use: `redis-cli -h $(getContainerAddress redis) -p 6379 -a <password>`
 - To check the Memcached use: `echo stats | nc $(getContainerAddress memcached) 11211`
 - To generate SSL certificates for your website use: `cd /var/www/ssl && mkcert <domain-1.local> <domain-2.local> ...`

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
 - `BASHR` - the same, but cli user is root
 - `CR` -  run from project folder root. Remove cache and static files directories
 - `SU` - run from project folder root. Execute `setup:upgrade` into docker container
 - `CC` - run from project folder root. Execute `cache:clean` into docker container
 - `CF` - run from project folder root. Execute `cache:flush` into docker container
 - `RE` - run from project folder root. Execute `indexer:reindex` into docker container
 - `SDC` - run from project folder root. Execute `setup:di:compile` into docker container
 - `SCD` - run from project folder root. Execute `setup:static-content:deploy` into docker container
 - `CRR` - run from project folder root. Execute `cron:run` into docker container
 - `CI` - run from project folder root. Execute `composer install` into docker container
