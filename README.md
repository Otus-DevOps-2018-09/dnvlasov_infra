# dnvlasov_infra
dnvlasov Infra repository
### ДЗ № 1

 Авторизация придложения Отус на Github. Создание Pull Request  в  в репозиторий Otus-DevOps-2018-09/students


### ДЗ № 2

- Закрепляем знания по GIT, работаем в репозиториях, созданных в рамках ДЗ №1
- Создаем интеграцию с чатом для репозитория и подключение Travis CI
1.  Клонирование репозитория из организации. 
 ```bash
  git clone git@github.com:Otus-DevOps-2018-09/dnvlasov_infra.git
 ```
2. Работа с ветками.
  - Перейти в директорию репозитория cd dnvlasov_infra.
  - Создать ветку необходимую для ДЗ  
```bash
 git checkout -b play-travis
```
3. Добавление изменений.
  - Создать директорию `".github"` скачать внутрь файл `PULL_REQUEST_TEMPLATE.md`
4. Отправка изменений.
  - Добавить файл `PULL_REQUEST_TEMPLATE.md` в индекс git'a  
 ```bash
 git add  PULL_REQUEST_TEMPLATE.md 
 ```
  - Сделать коммит.
   ```bash
   git commit -m 'Add PR template' 
   ```
  - Отправить изменения на github
   ```bash
   git push --set-upstream origin play-travis
   ```
5. Создание канала в slack.
6. Добавление пользователей.
7. Интеграция с github.
  - Набрать команду в своем slack канале
   ```slack
   /github subscribe Otus-DevOps-2018-09/dnvlasov_infra commits:all
   ```
9. Тестируем интерацию.
   - Скачать файл test.py в папку play_travis. Проверить что выдает канал.
10. Инструкции по сборке. 
  - Создать в корне репозитория файл  .travis.yml c содержимым:
    ```yml 
    dist: trusty
    sudo: required
    language: bash
    before_install:
    - curl https://raw.githubusercontent.com/express42/otus-homeworks/2018-09/run.sh | bash 
    ```
11. Интеграция slack  с github.
12. Интеграция Slack c Travis CI.
13. Хранение секретов.
  ```bash
  gem install travis 
 travis login --com 
 travis encrypt "devops-team-otus:<токен>#<канала>"\  --add notifications.slack.rooms --com
```
### ДЗ № 3

1. Создание учетной записи в Google Cloud Platform.
2. Создаем новый проект.
3. Работа с Google Compute Engine.
4. Работа с GCE: Метаданные добавить ключи ssh.
5. Генерация пары ключей.
```bash
ssh-keygen -t rsa -f ~/.ssh/appuser -C appuser -P ""
```
 - Приватный ключ: ~/.ssh/appuser
 - Публичный ключ: ~/.ssh/appuser.pub

6. Вносим в форму публичный ключ.
7. Создаем Экземпляр VM (инстанс) `bastion`
8. Проверяем подключение по полученному внешнему адресу.
```bash
ssh -i ~/.ssh/appuser appuser@<внешний IP VM>
```
9. Создаем вторую VM без внешней сети `someinternalhost`.
10. Используем Bastion host для прямого подключения к инстансам
внутренней сети.
 - Настроим SSH Forwarding на вашей локальной машине:
```bash
$ ssh-add -L
The agent has no identities
```
 - Добавим приватный ключ в ssh агент авторизации:
```bash
$ ssh-add ~/.ssh/appuser
Identity added: /Users/otus/.ssh/appuser (/Users/otus/.ssh/appuser)
```
11. Используем Bastion host для сквозного подключения
    ```
        ssh -i ~/.ssh/appuser -A appuser@(bastion_IP)
    ```
```text
bastion_IP = 204.155.26.14
someinternalhost_IP = 10.132.0.3
```
12. Создаем VPN-сервер для серверов GCP
- В настройках VM Брандмауэры разрешить трафик `HTTP и HTTPS`
- На хосте bastion выполняем команды [Ссылка на gist](https://gist.github.com/Nklya/df07e99e63e4043e6a699060a7e30b66)
```bash
$ cat <<EOF> setupvpn.sh
#!/bin/bash
echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" >
apt/sources.list.d/mongodb-org-3.4.list
echo "deb http://repo.pritunl.com/stable/apt xenial main" > /etc/apt/sources.list
pritunl.list
apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv
0C49F3730359A14518585931BC711F9BA15703C6
apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv
7568D9BB55FF9E5287D586017AE645C0CF8E292A
apt-get --assume-yes update
apt-get --assume-yes upgrade
apt-get --assume-yes install pritunl mongodb-org
systemctl start pritunl mongod
systemctl enable pritunl mongod
EOF
```
- Затем выполняем:
```bash
$ sudo bash setupvpn.sh
```
В результате:
- В текущей директории будет создан файл `setupvpn.sh`,
описывающий установку VPN-сервера
- Будет установлена mongodb и VPN-cервер pritunl
- Открываем в браузере ссылку: `https://<адрес bastion
VM>/setup`
- Ошибку SSL пропускаем и доверяем этому сайту 
- Cледуем инструкциям на экране (запрашиваемые
команды запускать через sudo)
- В конце установки авторизуемся, используя логин/пароль
pritunl/pritunl
- Далее добавляем в веб интерфейсе:
- Организацию
- Пользователя test с PIN
6214157507237678334670591556762
- Сервер (затем привязываем его к организации и
запускаем)
- Создадим правило для открытия порта VPN,  (порт указывается при создании
сервера).
- Добавим в инстансе bastion в Теги сети наше новое
правило
- Cкачать конфигурационный файл для подключени OpenVPNсервер
Pritunl
13. Проверяем подключение к VPN.
- Добавим полученный конфигурационный файл *.ovpn в
клиент OpenVPN на  компьютере
- Проверем подключение к VPN-серверу
- Проверем возможность подключения к someinternalhost
с компьютера, после подключения к VPN:
```bash
$ ssh -i ~/.ssh/appuser appuser@<внутренний IP someinternalhost>
```

### ДЗ №4
#### План
В данном ДЗ мы:
- Установим и настроим gcloud для работы с нашим
аккаунтом
- Создадим хост с помощью gcloud
- Установим на нем ruby для работы приложения
- Установим MongoDB и запустим
- Задеплоим тестовое приложение, запустим и проверим
его работу.
1. Установите Google Cloud SDK
    1. Создайте переменную окружения для правильного распространения:
    ```bash
    export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
    ```
    2. Добавить  Cloud SDK репозиторий в source.list:
    ```bash
    echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
    ```
    3. Импортировать публичные ключи Google Cloud:
    ```bash
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
    ```
    4. Обновление репозитория и установка Cloud SDK:
    ```bash
    sudo apt-get update && sudo apt-get install google-cloud-sdk
    ```
    5. Опционально должны установиться пакеты:
        - google-cloud-sdk-app-engine-python
        - google-cloud-sdk-app-engine-python-extras
        - google-cloud-sdk-app-engine-java
        - google-cloud-sdk-app-engine-go
        - google-cloud-sdk-datalab
        - google-cloud-sdk-datastore-emulator
        - google-cloud-sdk-pubsub-emulator
        - google-cloud-sdk-cbt
        - google-cloud-sdk-cloud-build-local
        - google-cloud-sdk-bigtable-emulator
        - kubectl 
    6. Запуск gcloud консоли
    ```bash
    gcloud init
    ```
2. Создаем новый инстанс.
```gcloud
gcloud compute instances create reddit-app\
  --project=infra-<id> \
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure
```    
3. Устанавливаем Ruby
- Подключаемся в к машине по SSH 
```bash 
$ ssh appuser@<instace_public_ip> 
```
- Обновляем APT и устанавливаем Ruby и Bundler:
```bash
$ sudo apt update
$ sudo apt install -y ruby-full ruby-bundler build-essential 
```
- Проверем установку Ruby и Bundler
```bash
$ ruby -v
$ bundle -v 
```
4. Устанавливаем MongoDB
```bash 
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
sudo bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list'
```
- Обновим индекс доступных пакетов и установим нужный
пакет: 
```bash
$ sudo apt update
$ sudo apt install -y mongodb-org
```
- Запускаем MongoDB:
```bash
$ sudo systemctl start mongod 
```
- Добавляем в автозапуск:
```bash
$ sudo systemctl enable mongod
```
5. Проверяем работу MongoDB
```bash
appuser@reddit-app:~$ sudo systemctl  status mongod
 mongod.service - High-performance, schema-free document-oriented database
   Loaded: loaded (/lib/systemd/system/mongod.service; enabled; vendor preset: enabled)
   Active: active (running) since Sat 2018-10-20 19:44:26 UTC; 17h ago
     Docs: https://docs.mongodb.org/manual
 Main PID: 13731 (mongod)
    Tasks: 20
   Memory: 32.8M
      CPU: 5min 23.343s
   CGroup: /system.slice/mongod.service
           └─13731 /usr/bin/mongod --quiet --config /etc/mongod.conf

Oct 20 19:44:26 reddit-app systemd[1]: Started High-performance, schema-free document-oriented database.
```
6. Деплой приложения.
- Копируем код приложения гаходясь в каталоге /home/appuser
```bash
$ git clone -b monolith https://github.com/express42/reddit.git 
```
- Переходим в директорию проекта и устанавливаем
зависимости приложения
```bash
$ cd reddit && bundle install
```
7. Деплой приложения
- Запускаем сервер приложения в папке проект
```bash
$ puma -d 
```
- Проверьте что сервер запустился и на каком порту
он слушает:
```bash 
$ ps aux | grep puma
appuser   9582  0.0  2.4 654684 42988  puma 3.10.0 (tcp://0.0.0.0:9292) [reddit]
```
testapp_IP = 35.236.29.190
testapp_IP = 9292 

7. Открываем порт в файерволе  
- create new firewall rule 
    - Name: default-puma-server
    - Targets tag: puma-server
    - Source IP ranges: 0.0.0.0/0
    - Specified protocols and ports: 9292
8. Проверка работы приложения
```http
http://testapp_IP:testapp_IP/
```
9. Дополнительное задание
- создать startup script, который будет запускаться при
создании инстанса
startup.sh 
```bash
#! /bin/bash

#install ruby
sudo apt update
sudo apt install -y ruby-full ruby-bundler build-essential

#install mongodb
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
sudo bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu\
        xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list'
sudo apt update
sudo apt install -y mongodb-org
sudo systemctl start mongod
sudo systemctl enable mongod

#deploy puma
cd /home/appuser
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install
puma -d
```
- перетать при установке
```gcloud
--metadata-from-file startup-script=startup.sh 
```
- так же  можно через http protocols
```gcloud
--metadata startup-script-url=https://github.com/Otus-DevOps-2018-09/dnvlasov_infra/blob/cloud-testapp/startup.sh
```
- Удалите созданное через веб интерфейс
правило для работы приложения default-pumaserver.
- Создайте аналогичное правило из консоли с
помощью gcloud.
- Используемую команду gcloud необходимо
добавить в описание репозитория (README.md)
```gcloud
gcloud compute firewall-rules create default-puma-server --allow tcp:9292 --source-ranges=0.0.0.0/0 --target-tags=puma-server
```
### ДЗ5
1. Установка packer
2. Создане ADC
```gcloud
$ gcloud auth application-default login
```
3. Создание Pcker template
- mkdir packer && touch packer/ubuntu16.json
```json
{
    "builders": [
        {
           "type": "googlecompute",
           "project_id": "infra-219415",
           "image_name": "reddit-base-{{timestamp}}",
           "image_family": "reddit-base",
           "source_image_family": "ubuntu-1604-lts",
           "zone": "europe-west1-b",
           "ssh_username": "appuser",
           "machine_type": "f1-micro"
         }
      ],
      "provisioners": [
              {
                      "type": "shell",
                      "inline":[
                             "sudo apt update"
                      ]
              },
              {
              "type": "shell",
              "script": "scripts/install_ruby.sh",
              "execute_command": "sudo {{.Path}}"
          },
          {
            "type": "shell",
            "script": "scripts/install_mongodb.sh",
            "execute_command": "sudo {{.Path}}"
          }
       ]
}
4. Скрипты для провижининга.
- mkdir packer/scripts && cp config-script/install-* packer/scripts 
5. Проверка на ошибки 
```bash
$ packer validate ./ubuntu16.json 
```
6. Packer build
- запустить build образа
```bash
$ packer build ubuntu16.json
```
7. Проверить созданный образ
- В браузерной консоле появился образ  ddit-base-1540144393
e. Деплоим приложение 
- Создаем машину из образа reddit-base-1540144393
8. Подключаемся по ssh
```bash
$ ssh appuser@<instace_public_ip>
```
9. Установка зависимостей и запуск приложения.
```bash
$ git clone -b monolith https://github.com/express42/reddit.git
$ cd reddit && bundle install
$ puma -d
```
- Проверить что приложение запустилось
```bash
$ ps aux | grep puma
```
10. Проверка работы приложения
```http
http://instace_public_ip:9292
```

