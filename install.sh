#!/bin/sh

# Sudo access will be requested if the script was not run with sudo or under root user
sudo -k

if ! [ "$(sudo id -u)" = 0 ]; then
    echo "\033[31;1m"
    echo "Root password was not entered correctly!"
    exit 1;
fi

sudo apt update -y
sudo apt upgrade -y


    printf "\n>>> Adding repositories and updating software list >>>\n"

# Install cUrl
sudo apt install curl -y

# PHP
sudo add-apt-repository ppa:ondrej/php -y
# Node
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
# Guake terminal
sudo add-apt-repository ppa:linuxuprising/guake -y
# Gogle drive Ocamlfuse
sudo add-apt-repository ppa:alessandro-strada/ppa


    printf "\n>>> Running Ubuntu upgrade >>>\n"

sudo apt update -y
sudo apt upgrade -y
sudo apt install net-tools -y


    printf "\n>>> Guake terminal is going to be installed >>>\n"

# Install Tilda
sudo apt install guake -y


    printf "\n>>> Git is going to be installed >>>\n"

# Install Git
sudo apt install git -y


    printf "\n>>> Google drive ocamlfuse - synchronizer for google drive is going to be installed. See README.md for configuring it >>>\n"

# Install Google drive ocamlfuse
sudo apt-get install google-drive-ocamlfuse -y


    printf "\n>>> MySQL and Redis Clients are going to be installed >>>\n"

# Install MySQL and Redis Clients
sudo apt install mysql-client -y
sudo apt install redis-tools -y


    printf "\n>>> Docker Infrastructure is going to be installed from https://github.com/BlackMaizeGod/docker_infrastructure.git >>>\n"

# Install Docker and docker-compose
sudo apt install docker.io docker-compose -y
sudo systemctl enable docker
# This is to execute Docker command without sudo. Will work after logout/login because permissions should be refreshed
sudo usermod -aG docker "${USER}"
# Clone Docker Infrastructure
sudo mkdir /var/www
sudo chown -R "${USER}" /var/www
curl https://raw.githubusercontent.com/BlackMaizeGod/docker_infrastructure/main/docker-compose.yml > /var/www/docker-compose.yml


    printf "\n>>> Creating files and folders... >>>\n"

# Directory /var/www/html serves for locating projects, /var/www/hosts for nginx configs
mkdir -p /var/www/hosts /var/www/html/example
printf "<?php\n\ndeclare(strict_types=1);\n\nphpinfo();" > /var/www/html/example/index.php
printf "server {
        listen 80;
        root /var/www/html/example;
        index index.php index.html index.htm;
        server_name example.local;

         #access_log /var/www/html/example/access.log;
         #error_log /var/www/html/example/error.log warn;

        location / {
            try_files \$uri \$uri/ =404;
        }

        location ~ \.php$ {
            try_files \$uri =404;
            fastcgi_split_path_info ^(.+\.php)(/.+)$;
            fastcgi_pass php7.4-fpm:9000;
            fastcgi_index index.php;
            include fastcgi_params;
            fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
            fastcgi_param PATH_INFO \$fastcgi_path_info;
        }
}" > /var/www/hosts/example.local.conf

# Configure infrastructure hosts
echo "

#### START: Docker Infrastructure

137.172.17.81              phpmyadmin.local              ### http://phpmyadmin.local/
137.172.17.25              mailhog                       ### http://mailhog:8025/
137.172.17.92              elasticsearch7                ### http://elasticsearch7:9200/
137.172.17.72              rabbitmq                      ### http://rabbitmq:15672/
137.172.17.80              example.local                 ### http://example.local/

#### END: Docker Infrastructure ###" | sudo tee -a /etc/hosts


    printf "\n>>> PHP and common packages are going to be installed >>>\n"

# Install PHP and common packages
sudo apt install php-cli php-xdebug php-json php-mysql php-zip php-gd php-mbstring php-curl php-xml php-pear php-bcmath -y
sudo bash -c "cat <<EOT>> $(php --ini | grep 'xdebug.ini' | awk '{t=length($0)}END{print substr($0,0,t-1)}')

xdebug.mode=debug
xdebug.client_host=127.0.0.1
xdebug.start_with_request=yes
xdebug.log=/dev/null
EOT"


    printf "\n>>> NPM is going to be installed >>>\n"

# Install Node Package Manager
sudo apt install nodejs -y
sudo apt install npm -y


    printf "\n>>> ESLint and Stylelint are going to be installed >>>\n"

# Install ESLint
sudo npm i -g eslint@7 --save-dev
# Install Stylelint
sudo npm i -g stylelint@13 --save-dev
# Configure directory rights
sudo chown -R "$USER" /usr/lib/node_modules
sudo chown -R "$USER" /usr/local/lib/node_modules


    printf "\n>>> Creating aliases and enabling color output >>>\n"

# Configure aliases
printf "force_color_prompt=yes
shopt -s autocd
set completion-ignore-case On

# PHP xDebug 3.x config
export XDEBUG_SESSION=PHPSTORM

getContainerName() {
  for file in /var/www/hosts/*.conf
  do
    if grep -q \"/var/www/html/\$(\"pwd\" | awk -F '/' '{print \$NF}');$\" \"\$file\"; then
      grep -o 'php.\..-fpm' \"\$file\";
    fi
  done
}

getContainerAddress() {
  docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' \"\$1\"
}

enterContainer() {
  docker exec -it \"\$1\" -w\"\$(pwd)\" \"\$(getContainerName)\" bash
}

executeCommand() {
  docker exec -it -u1000 -w\"\$(pwd)\" \"\$(getContainerName)\" php bin/magento \"\$@\"
}

noContainer() {
  printf \"
###############################################
# Infrastructure has not a suitable container #
###############################################

\"
}

alias MY56='mysql -uroot -proot -h\"\$(getContainerAddress mysql56)\" --show-warnings'
alias MY57='mysql -uroot -proot -h\"\$(getContainerAddress mysql57)\" --show-warnings'
alias MY80='mysql -uroot -proot -h\"\$(getContainerAddress mysql80)\" --show-warnings'
alias MY101='mysql -uroot -proot -h\"\$(getContainerAddress mariadb101)\" --show-warnings'
alias MY102='mysql -uroot -proot -h\"\$(getContainerAddress mariadb102)\" --show-warnings'
alias MY103='mysql -uroot -proot -h\"\$(getContainerAddress mariadb103)\" --show-warnings'
alias MY104='mysql -uroot -proot -h\"\$(getContainerAddress mariadb104)\" --show-warnings'

alias RNG='docker exec -it nginx service nginx restart'
alias BASH='[ -n \"\$(getContainerName)\" ] && enterContainer -u1000 || noContainer'
alias BASHR='[ -n \"\$(getContainerName)\" ] && enterContainer -uroot || noContainer'

alias CR='rm -rf var/cache/* var/page_cache/* var/view_preprocessed/* var/di/* var/generation/* generated/code/* generated/metadata/* pub/static/frontend/* pub/static/adminhtml/* pub/static/deployed_version.txt'

alias SU='executeCommand setup:upgrade'
alias CC='executeCommand cache:clean'
alias CF='executeCommand cache:flush'
alias RE='executeCommand indexer:reindex'
alias SDC='executeCommand setup:di:compile'
alias SCD='executeCommand setup:static-content:deploy'
alias CRR='executeCommand cron:run'
alias CI='docker exec -it -u1000 -w\"\$(pwd)\" \"\$(getContainerName)\" composer install'" >> ~/.bash_aliases


    printf "\n>>> Magento 2 coding standards is going to be installed - https://github.com/magento/magento-coding-standard >>>\n"

# Install Coding Standards
cd /var/www/html/ && git clone https://github.com/magento/magento-coding-standard.git
cd /var/www/html/magento-coding-standard && git config core.fileMode false


    printf "\n>>> Start System Configuring >>>\n"

# Add empty document template to context menu
touch ~/Templates/document.txt

# Customize terminal
printf "\nPS1='\${debian_chroot:+(\$debian_chroot)}\[\\\033[01;35m\][\d \\\t] \[\\\033[01;33m\]\w\[\\\033[01;31m\]\[\\\033[01;34m\]\[\\\033[01;31m\] > \[\\\033[01;32m\]'" >> ~/.bashrc

# Enable nano editor syntax highlights
cp /etc/nanorc ~/.nanorc
printf "\n#Syntax Highlights:\n\n" >> ~/.nanorc
find /usr/share/nano/ -iname "*.nanorc" -exec echo include {} \; >> ~/.nanorc

# Add custom keybinding
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/','/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/']"

# Configure Flameshot
gsettings set org.gnome.settings-daemon.plugins.media-keys screenshot '[]'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'flameshot'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command '/usr/bin/flameshot gui'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding 'Print'

# Configure Diodon clipboard manager
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name 'diodon'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command '/usr/bin/diodon'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding '<Ctrl><ALT>H'

# Disable lock screen when inactive
gsettings set org.gnome.desktop.session idle-delay 0
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
gsettings set org.gnome.settings-daemon.plugins.power idle-dim false

# Show battery percentage
gsettings set org.gnome.desktop.interface show-battery-percentage true

# Rebind F1 default binding - help browser to suspend
gsettings set org.gnome.settings-daemon.plugins.media-keys help '[]'
gsettings set org.gnome.settings-daemon.plugins.media-keys screensaver "['<Super>F1']"

# Add languages switching
gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('xkb', 'ru'), ('xkb', 'ua')]"
gsettings set org.gnome.desktop.input-sources xkb-options "['grp:alt_shift_toggle']"

# Check if exist autostart config directory and create if not
if [ ! -d ~/.config/autostart ]; then
  mkdir -p ~/.config/autostart
fi

# Configure autostart programs
printf "[Desktop Entry]
Name=Guake Preferences
Comment=Configure your Guake sessions
TryExec=guake
Exec=guake -p
Icon=guake
Type=Application
StartupNotify=true
Categories=GTK;GNOME;Settings;X-GNOME-PersonalSettings;
X-GNOME-Settings-Panel=guake
X-Desktop-File-Install-Version=0.15
Keywords=Terminal;Utility;" > ~/.config/autostart/guake-prefs.desktop

printf "[Desktop Entry]
Name=flameshot
Icon=flameshot
Exec=flameshot
Terminal=false
Type=Application
X-GNOME-Autostart-enabled=true" > ~/.config/autostart/flameshot.desktop

# shellcheck disable=SC2183
printf "[Desktop Entry]
Type=Application
Version=1.0
Name=Diodon
GenericName[bg]=Мениджър на системния буфер
GenericName[ca]=Gestor de porta-retalls
GenericName[cs]=Správce schránky
GenericName[de]=Zwischenablage-Verwaltung
GenericName[en_GB]=Clipboard Manager
GenericName[es]=Gestor del portapapeles
GenericName[et]=Lõikepuhvrihaldur
GenericName[fi]=Leikepöydän hallinta
GenericName[fr]=Gestionnaire de presse-papier
GenericName[gl]=Xestor do portapapeis
GenericName[hu]=Vágólapkezelő
GenericName[it]=Gestore degli appunti
GenericName[ja]=クリップボードマネージャー
GenericName[lt]=Iškarpinės tvarkytuvė
GenericName[nb]=Utklippstavle-behandler
GenericName[nl]=Klembordbeheer
GenericName[pl]=Menadżer Schowka
GenericName[pt]=Gestor da Área de Transferência
GenericName[pt_BR]=Gerenciador de área de transferência
GenericName[ro]=Administrator clipboard
GenericName[ru]=Менеджер буфера обмена
GenericName[se]=Čuohpusgirjigieđahalli
GenericName[sk]=Správca schránky
GenericName[sv]=Urklipphanterare
GenericName[tr]=Pano Yöneticisi
GenericName[uk]=Менеджер буферу обміну
GenericName[zh_CN]=剪贴板管理器
GenericName=Clipboard Manager
Comment[ca]=Gestor porta-retalls GTK+
Comment[cs]=GTK+ Správce schránky
Comment[de]=GTK+-Zwischenablage-Verwaltung
Comment[en_GB]=GTK+ Clipboard Manager
Comment[es]=Gestor del portapapeles GTK+
Comment[et]=GTK+ lõikepuhvrihaldur
Comment[fi]=GTK+-pohjainen leikepöydän hallinta
Comment[fr]=Gestionnaire de presse-papier GTK+
Comment[gl]=Xestor do portapapeis en GTK+
Comment[hu]=GTK+ Vágólapkezelő
Comment[it]=GTK+ Clipboard Manager
Comment[ja]=GTK+クリップボードマネージャー
Comment[lt]=GTK+ iškarpinės tvarkytuvė
Comment[nb]=GTK+ håndtering av utklippstavle
Comment[nl]=GTK+-klembordbeheer
Comment[pl]=Menadżer schowka GTK+
Comment[pt]=Gestor da Área de Transferência GTK+
Comment[pt_BR]=Gerenciador de área de transferência em GTK+
Comment[ro]=Administrator clipboard pentru mediul GTK+
Comment[ru]=Менеджер буфера обмена на базе GTK+
Comment[se]=GTK+ Čuohpusgirjigieđahalli
Comment[sv]=GTK+ Urklipphanterare
Comment[tr]=GTK+ Pano Yöneticisi
Comment[uk]=GTK+ Менеджер буферу обміну
Comment[zh_CN]=GTK+ 剪贴板管理器
Comment=GTK+ Clipboard Manager
Icon=diodon
NotShowIn=KDE;
Exec=diodon %u
Terminal=false
Categories=GTK;GNOME;Utility;
StartupNotify=false
MimeType=x-scheme-handler/clipboard;" > ~/.config/autostart/diodon.desktop


# System reboot
    printf "\033[31;1m"
# shellcheck disable=SC2039,SC3045
read -r -p "/**********************
*
*    ATTENTION!
*
*    System is going to be restarted
*
*    PRESS ANY KEY TO CONTINUE
*
\**********************
" nothing

printf "\n*** Job done! Going to reboot in 5 seconds... ***\n"

sleep 5
sudo reboot