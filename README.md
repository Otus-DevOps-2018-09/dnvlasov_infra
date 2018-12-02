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
### ДЗ №5
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
11.Самостоятельные задания.
  1. Необходимо параметризировать созданный шаблон, используя
пользовательские переменные
   - ID проекта (обязательно)
   - source_image_family (обязательно)
   - machine_type
  2. Пользовательские переменные определяются в самом
шаблоне, в файле `variables.json` задаются обязательные
переменные, либо переопределяются
-- variables.json
```json
{
        "project_id": "infra-3324235",
        "source_image_family": "ubuntu-1604-lts",
        "machine_type": "f1-micro",
}
```
-- ubuntu16.json
```json
{
    "variables":{
        "project_id": "variables.json",
        "machine_type": "variables.json",
        "source_image_family": "variables.json",
        },
    "builders": [
        {
           "type": "googlecompute",
           "project_id": "{{user `project_id`}}",
           "image_name": "reddit-base-{{timestamp}}",
           "image_family": "reddit-base",
           "source_image_family": "{{user `source_image_family`}}",
           "zone": "europe-west1-b",
           "ssh_username": "",
           "machine_type": "{{user `machine_type`}}",
           }
```
- Стартуем билд командой   $ packer build -var-file=variables.json  ubuntu16.json
   
3. Исследовать другие опции builder для GCP (ссылка).
      - Описание образа
      -  Размер и тип диска
      -  Название сети
      - Теги

-- variables.json
```json
{
        "project_id": "infra-000000",
        "source_image_family": "ubuntu-1604-lts",
        "machine_type": "f1-micro",
        "network": "default",
        "tags": "puma-server",
        "disk_type": "pd-ssd",
        "disk_size": "10",
        "image_description": "Canonical, Ubuntu, 16.04 LTS, amd64 xenial image"
}
```
-- ubuntu16.json
```json
{
    "variables":{
        "project_id": "variables.json",
        "machine_type": "variables.json",
        "source_image_family": "variables.json",
        "networks": "variables.json",
        "tags": "variables.json",
        "disk_type": "variables.json",
        "disk_size": "variables.json",
        "image_description": "variables.json"
        },
    "builders": [
        {
           "type": "googlecompute",
           "project_id": "{{user `project_id`}}",
           "image_name": "reddit-base-{{timestamp}}",
           "image_family": "reddit-base",
           "source_image_family": "{{user `source_image_family`}}",
           "zone": "europe-west1-b",
           "ssh_username": "",
           "machine_type": "{{user `machine_type`}}",
           "network": "{{user `network`}}",
           "tags": "{{user `tags`}}",
           "disk_type": "{{user `disk_type`}}",
           "disk_size": "{{user `disk_size`}}",
           "image_description": "{{user `image_descriprion`}}"
         }
      ],
```
### ДЗ №6
#### Практика IaC с использованием Terraform

1. Создаем новую ветку terraform-1
```git
 git checkout -b terraform-1
 ```
2. Устанавливаем terraform 
 ```bash
 wget https://releases.hashicorp.com/terraform/0.11.10/terraform_0.11.10_linux_amd64.zip
 ```
 Паспаковываем файл в папку указаной в PATH  в окружении пользователя.
 ```bash
 unzip terraform_0.11.10_linux_amd64.zip -d ~/otus
```
В папке terraform создаем файл main.tf. Это будет главный конфигурационный файл в этом задании, который будет содержать декларативное описание нашей инфраструктуры. В корне репозитория создайте файл .gitignore с
содержимым указанным в данном gist.
```gitignore
*.tfstate
*.tfstate.*.backup
*.tfstate.backup
*.tfvars
.terraform/ 
```
 Это необходимо для того, чтобы не коммитить в
репозиторий служебные файлы и директории.

3. Provider

Первый делом определим секцию Provider в файле
main.tf, которая позволит Terraform управлять
ресурсами GCP через API вызовы
```tf
provider "google" {
 version = "1.4.0"
 project =
"steam-strategy-174408"
 region = "europe-west1"
}
```
4. Terraform init

Провайдеры Terraform являются загружаемыми
модулями, начиная с версии 0.10. Для того чтобы
загрузить провайдер и начать его использовать
выполните следующую команду в директории terraform:
```tr
$ terraform init
```
Должны увидеть сообщение, что провайдер был
установлен и инициализация Terraform прошла
успешно

```bash
Initializing provider plugins...

Terraform has been successfully initialized!
```

5. Ресурсная модель

Чтобы запустить VM при помощи terraform нам нужно
воспользоваться ресурсом google_compute_instance,
который позволяет управлять инстансами VM.

В файле main.tf после определения провайдера, добавьте
ресурс для создания инстанса VM в GCP.
```tf
resource "google_compute_instance" "app" {
 name = "reddit-app"
 machine_type = "g1-small"
 zone = "europe-west1-b"
 # определение загрузочного диска
 boot_disk {
 initialize_params {
 image = "reddit-base-1540144393"
  }
 }
 # определение сетевого интерфейса
 network_interface {
 # сеть, к которой присоединить данный интерфейс
 network = "default"
 # использовать ephemeral IP для доступа из Интернет
 access_config {}
 }
}
```
Перед тем как дать команду terraform'у применить
изменения, хорошей практикой является
предварительно посмотреть, какие изменения
terraform собирается произвести относительно
состояния известных ему ресурсов (tfstate файл), и
проверить, что мы действительно хотим сделать
именно эти изменения.
Выполните команду планирования изменений в
директории terraform:
```bash
$ terraform plan 
```
6. Планируем изменения

Знак "+" перед наименованием ресурса означает, что
ресурс будет добавлен. Далее приведены атрибуты
этого ресурса. “<computed>” означает, что данные
атрибуты еще не известны terraform'у и их значения
будут получены во время создания ресурса.

```bash
+ google_compute_instance.app
 boot_disk.#: "1"
 boot_disk.0.auto_delete: "true"
 boot_disk.0.device_name: "<computed>"
 boot_disk.0.disk_encryption_key_sha256: "<computed>"
 boot_disk.0.initialize_params.#: "1"
 boot_disk.0.initialize_params.0.image: "reddit-base"

 Plan: 1 to add, 0 to change, 0 to destroy.
 ```
 #### 7. Создаем VM согласно описанию
Для того чтобы запустить инстанс VM, описание
характеристик которого мы привели в
конфигурационном файле main.tf, используем команду:
```bash
$ terraform apply 
```
##### * Начиная с версии 0.11 terraform apply запрашивает дополнительное подтверждение
при выполнении. Необходимо добавить 
`-auto-approve=true` для отключения этого.
В результате применения команды увидим, какие
изменения были произведены terraform'ом: 

```bash
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```
Результатом выполнения команды также будет
создание файла `terraform.tfstate` в директории
terraform. Terraform хранит в этом файле состояние
управляемых им ресурсов.
В этом  файле  внешний IP адрес
созданного инстанса, его можно найти командой. 

```bash
$ terraform show | grep assigned_nat_ip
```
#### 8. Подключение к инстансупо SSH
Добавить в main.tf к 
```tf
resource "google_compute_instance" "app" {
...
metadata {
 ssh-keys = "appuser:${file("~/.ssh/appuser.pub")}"
 }
...
}
```
Планируем изменения 
```bash
terraform plan
```
Применяем изменения.
```
terraform apply
```
#### 9. Output vars
Выновим интересующую нас информацию -
внешний адрес VM - в выходную переменную
(output variable)
Создаем  файл outputs.tf в директории terraform со
следующим содержимым.
```tr
output "app_external_ip" {
 value = "${google_compute_instance.app.network_interface.0.access_config.0.assigned_nat_ip}"
}
```
Используем команду `terraform refresh`, чтобы
выходная переменная приняла значение.
```bash
Outputs:
app_external_ip = 104.155.68.69
```
Значение выходных переменным можно
посмотреть, используя команду terraform output:
```bash
$ terraform output
app_external_ip = 104.155.68.69
$ terraform output app_external_ip
104.155.68.69
```
#### 10. Откроем порт для приложения

Добавим в main.tf следущий ресурс:
```tr
resource "google_compute_firewall" "firewall_puma" {
 name = "allow-puma-default"
# Название сети, в которой действует правило
 network = "default"
# Какой доступ разрешить
 allow {
 protocol = "tcp"
 ports = ["9292"]
 }
# Каким адресам разрешаем доступ
 source_ranges = ["0.0.0.0/0"]
# Правило применимо для инстансов с перечисленными тэгами
 target_tags = ["reddit-app"]
} 
```
Планируем и применяем изменения
```bash
$ terraform plan
$ terraform apply 
```
#### 11. Добавляем тег инстансу VM
Добавим тег в определении ресурса. 

```bash
resource "google_compute_instance" "app" {
 name = "reddit-app"
 machine_type = "g1-small"
 zone = "europe-west1-b"
 tags = ["reddit-app"]
 ```
 Планируем изменения
 ```shell
$ terraform plan
...
 ~ google_compute_instance.app
 tags.#: "0" => "1"
 tags.1799682348: "" => "reddit-app"
Plan: 0 to add, 1 to change, 0 to destroy. 
```
Видим, что ресурс виртуальной машины будет изменен.

Применяем изменения
```bash
$ terraform apply 
```
#### 12. Provisioners
Provisioners в terraform вызываются в момент
создания/удаления ресурса и позволяют выполнять
команды на удаленной или локальной машине. Их
используют для запуска инструментов управления
конфигурацией или начальной настройки системы.
Используем провижинеры для деплоя последней
версии приложения на созданную VM

Внутрь ресурса, содержащего описание VM,
вставьте секцию провижинера типа file, который
позволяет копировать содержимое файла на
удаленную машину.
```bash
provisioner "file" {
source = "files/puma.service"
destination = "/tmp/puma.service"
} 
```
Говорим, провижинеру
скопировать локальный файл, располагающийся по
указанному относительному пути `(files/puma.service)`, в указанное место на удаленном хосте.
#### 13. Unit file для Puma
Создадим директорию files внутри директории
terraform и создадим внутри нее файл puma.service
```
[Unit]
Description=Puma HTTP Server
After=network.target

[Service]
Type=simple
User=appuser
WorkingDirectory=/home/appuser/reddit
ExecStart=/bin/bash -lc 'puma'
Restart=always

[Install]
WantedBy=multi-user.target
```
Добавим еще один провиженер для запуска скрипта
деплоя приложения на создаваемом инстансе.
Сразу же после определения провижинера file
(провижинеры выполняются по порядку их
определения), вставьте секцию провижинера
remote-exec
```tf
provisioner "remote-exec" {
 script = "files/deploy.sh"
}
```
Создайте файл deploy.sh в директории terraform/files с содержимым
```
#!/bin/bash
set -e

APP_DIR=${1:-$HOME}

git clone -b monolith https://github.com/express42/reddit.git $APP_DIR/reddit
cd $APP_DIR/reddit
bundle install

sudo mv /tmp/puma.service /etc/systemd/system/puma.service
sudo systemctl start puma
sudo systemctl enable puma
}
```
#### 14. Параметры подключения provisioners
Определим параметры подключения провиженеров к
VM. Внутрь ресурса VM, перед определением
провижинеров, добавьте следующую секцию:

```
connection {
 type = "ssh"
 user = "appuser"
 agent = false
 private_key = "${file("~/.ssh/appuser")}"
 }
 ```
В данном примере мы указываем, что провижинеры,
определенные в ресурсе VM, должны подключаться к
созданной VM по SSH, используя для подключения
приватный ключ пользователя appuser

- Ресурс для VM сейчас выглядит следующим образом

```
 resource "google_compute_instance" "app" {
  name         = "reddit-app"
  machine_type = "g1-small"
  zone         = "europe-west1-b"

  # определение загрузочного диска
  boot_disk {
    initialize_params {
      image = "reddit-base"
    }
  }

  metadata {
    ssh-keys = "appuser:${file("~/.ssh/appuser.pub")}"
  }

  tags = ["reddit-app"]

  # определение сетевого интерфейса
  network_interface {
    # сеть, к которой присоединить данный интерфейс
    network = "default"

    # использовать ephemeral IP для доступа из Интернет
    access_config {}
  }

  connection {
    type        = "ssh"
    user        = "appuser"
    agent       = false
    private_key = "${file("~/.ssh/appuser")}"
  }

  provisioner "file" {
    source      = "files/puma.service"
    destination = "/tmp/puma.service"
  }

  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }
}

```
#### 15. Проверяем работу провижинеров
Terraform предлагает команду `taint`, которая
позволяет пометить ресурс, который terraform
должен пересоздать, при следующем запуске `
terraform apply`.
Говорим terraform'y пересоздать ресурс VM при
следующем применении изменений:
```
$ terraform taint google_compute_instance.app
The resource google_compute_instance.app in the module root
has been marked as tainted!
```
Планируем изменения:
```
$ terraform plan
...
-/+ google_compute_instance.app (tainted) (new resource required)
 boot_disk.#: "1" => "1"
 boot_disk.0.auto_delete: "true" => “true"
 ```
-/+ означает, что ресурс будет удален и создан вновь

```
$ terraform apply 
```
#### 16. Используем input переменные

Определим соответствующие параметры ресурсов
main.tf через переменные:
```
provider "google" {
 version = "1.4.0"
 project = "${var.project}"
 region = "${var.region}"
}
boot_disk {
 initialize_params {
 image = "${var.disk_image}"
 }
}
metadata {
 ssh-keys = "appuser:${file(var.public_key_path)}"
 } 
 ```

В директории terraform создайте файл terraform.tfvars, в котором определим переменные.
```
project = "infra-179015"
public_key_path = "~/.ssh/appuser.pub"
disk_image = "reddit-base" 
```
#### 17. Финальная проверка
Пересоздадим все ресурсы созданные при помощи terraform. 
```
$ terraform destroy
...
Do you really want to destroy?
 Terraform will delete all your managed infrastructure, as shown above.
 There is no undo. Only 'yes' will be accepted to confirm.
 Enter a value: yes
```
Затем создадим ресурсы вновь. Terraform автоматически будет
использовать переменные, определенные в terraform.tfvars 
```
$ terraform plan
$ terraform apply
```
#### 17. Финальная проверка

 http://35.240.115.111

#### 18. Самостоятельные задания
1. Определите input переменную для приватного ключа,
использующегося в определении подключения для
провижинеров (connection); 
```
connection {
    type = "ssh"
    user = "appuser"
    agent = false
    private_key = "${file(var.private_key)}"
}
```
2. Определите input переменную для задания зоны в ресурсе
"google_compute_instance" "app". У нее должно быть
значение по умолчанию; 
```
main.tf
zone = "${var.zone}
```
```
variable.tf

variable zone {
        description = "Zone"
}
```
```
terraform.tfvars

zone = "zone name"
```
### ДЗ №7
Определим ресурс файервола.
```
resource "google_compute_firewall" "firewall_ssh" { name = "default-allow-ssh"
network = "default"
allow {
protocol = "tcp" ports = ["22"]
}
source_ranges = ["0.0.0.0/0"] }
```
Выполним команду применения изменений: ...
```
google_compute_firewall.firewall_ssh: 1 error(s) occurred:
 $ terraform apply
google_compute_instance.app: Refreshing state... (ID: reddit-app)

*google_compute_firewall.firewall_ssh: Error creating firewall: googleapi: Error 409: The resource 'projects/infra-179014/global/firewalls/default-allow-ssh' already exists, alreadyExists
```
Правило firewall/default-allow-ssh уже существует.

Импортируем существующую инфраструктуру в Terraform
```
$ terraform import google_compute_firewall.firewall_ssh default-allow-ssh
 
google_compute_firewall.firewall_ssh: Importing from ID "default-allow-ssh"...
google_compute_firewall.firewall_ssh: Import complete!
Imported google_compute_firewall (ID: default-allow-ssh)
google_compute_firewall.firewall_ssh: Refreshing state... (ID: default-allow-ssh)
Import successful!
```
#### Ресурс IP адреса

Зададим IP для инстанса с приложением в виде внешнего ресурса. Для этого определим ресурс google_compute_address в конфигурационном файле main.tf
```
resource "google_compute_address" "app_ip" { name = "reddit-app-ip"
}
```
Ссылаемся на атрибуты другого ресурса Для того чтобы использовать созданный IP адрес в нашем ресурсе VM нам необходимо сослаться на атрибуты ресурса, который этот IP создает, внутри конфигурации ресурса VM. В конфигурации ресурса VM определите, IP адрес для создаваемого инстанса.
```
network_interface { network = "default" access_config = {
nat_ip = "${google_compute_address.app_ip.address}" }
     15
}
```
#### Неявная зависимость.

Ссылку в одном ресурсе на атрибуты другого тераформ понимает как зависимость одного ресурса от другого. Это влияет на очередность создания и удаления ресурсов при применении изменений. Вновь пересоздадим все ресурсы и посмотрим на очередность создания ресурсов сейчас
```
 $ terraform destroy
 $ terraform plan
 $ terraform apply
google_compute_address.app_ip: Creating...
google_compute_firewall.firewall_puma: Creating...
google_compute_firewall.firewall_ssh: Creating...
...
google_compute_address.app_ip: Creation complete after 12s (ID: reddit-app-ip)
google_compute_instance.app: Creating...
```
Видим, что ресурс VM начал создаваться только после завершения создания IP адреса в результате неявной зависимости этих ресурсов.

#### Структуризация ресурсов Несколько VM

Вынесем БД на отдельный инстанс VM. Для этого необходимо в директории packer, где содержатся ваши шаблоны для билда VM, создать два новых шаблона db.json и app.json. При помощи шаблона db.json должен собираться образ VM, содержащий установленную MongoDB. Шаблон app.json должен использоваться для сборки образа VM, с установленными Ruby. В качестве базового образа для создания образа возьмем ubuntu16.04.

#### Создадим две VM

Разобьем конфиг main.tf на несколько конфигов. Создадим файл app.tf, куда вынесем конфигурацию для VM с приложением.

Образ приложения.

variables.tf:
```
variable app_disk_image {
description = "Disk image for reddit app" default = "reddit-app-base"
}
```
app.tf
```
resource "google_compute_instance" "app" { name = "reddit-app"
machine_type = "g1-small"
zone = "${var.zone}"
tags = ["reddit-app"] boot_disk {
initialize_params {
image = "${var.app_disk_image}"
} }
network_interface { network = "default" access_config = {
nat_ip = "${google_compute_address.app_ip.address}" }
}
metadata {
ssh-keys = "appuser:${file(var.public_key_path)}" }
}
```
Добавим в app.tf определение правила фаервола для сервера приложения и создание IP адреса.
```
resource "google_compute_address" "app_ip" { name = "reddit-app-ip"
}
resource "google_compute_firewall" "firewall_puma" {
name = "allow-puma-default" network = "default"
allow {
protocol = "tcp" ports = ["9292"]
}
source_ranges = ["0.0.0.0/0"] target_tags = ["reddit-app"]
}
```
Объявить переменную в variables.tf
```
variable db_disk_image {
description = "Disk image for reddit db" default = "reddit-db-base"
}
```
Создадим файл db.tf, в котором определим ресурсы для запуска VM с БД.
```
resource "google_compute_instance" "db" { name = "reddit-db"
machine_type = "g1-small"
zone = "${var.zone}"
tags = ["reddit-db"] boot_disk {
initialize_params {
image = "${var.db_disk_image}"
} }
network_interface { network = "default" access_config = {}
}
metadata {
ssh-keys = "appuser:${file(var.public_key_path)}" }
}
```
Добавим в db.tf правило файервола, которое даст доступ приложению к БД
```
resource "google_compute_firewall" "firewall_mongo" { name = "allow-mongo-default"
network = "default"
allow {
protocol = "tcp" ports = ["27017"]
}
```
 правило применимо к инстансам с тегом ...
```target_tags = ["reddit-db"]```
 порт будет доступен только для инстансов с тегом ... ```source_tags = ["reddit-app"]
}```
Создадим файл vpc.tf в который вынесем правило фаервола для ssh доступа, которое применимо для всех инстансов нашей сети.
```
resource "google_compute_firewall" "firewall_ssh" { name = "default-allow-ssh"
network = "default"
allow {
protocol = "tcp" ports = ["22"]
}
source_ranges = ["0.0.0.0/0"] }
В файле main.tf остаться только определение провайдера:

provider "google" {
version = "1.4.0"
project = "${var.project}" region = "${var.region}"
}
```
#### Модули

Разбиваем нашу конфигурацию на отдельные конфиг файлы.

Внутри директории terraform создайте директорию modules, в которой мы будет определять модули.

DB module Внутри директории modules создайте директорию db, в которой создайте три привычных нам файла main.tf, variables.tf, outputs.tf. Скопируем содержимое db.tf, который мы создали ранее, в modules/db/main.tf. Затем определим переменные, которые у нас используются в db.tf и объявляются в variables.tf в файл переменных модуля modules/db/variables.tf

```
variable public_key_path {
description = "Path to the public key used to connect to instance"
}
variable zone { description = "Zone"
}
variable db_disk_image {
description = "Disk image for reddit db" default = "reddit-db-base"
```
App module

Создадим по аналогии модуль приложения: в директории modules создадим директорию app, в которой создайте три привычных нам файла main.tf, variables.tf, outputs.tf.

Скопируем содержимое app.tf, который мы создали ранее, в modules/app/main.tf

Затем определим переменные, которые у нас используются в app.tf и объявляются в variables.tf в файл переменных модуля modules/app/variables.tf
```
variable public_key_path {
description = "Path to the public key used to connect to instance"
}
variable zone { description = "Zone"
}
variable app_disk_image {
description = "Disk image for reddit app" default = "reddit-app-base"
}
```
Выходные переменные
```
modules/app/outputs.tf
output "app_external_ip" {
value = "${google_compute_instance.app.network_interface.0.access_config.
0.assigned_nat_ip}"
}
```
Проверим работу модулей

В файл main.tf, где у нас определен провайдер вставим секции вызова созданных нами модулей

terraform/main.tf
```
...
module "app" {
Источник, откуда копировать модуль
source = "modules/app" public_key_path = "${var.public_key_path}" zone = "${var.zone}" app_disk_image = "${var.app_disk_image}"
}
module "db" {
source = "modules/db" public_key_path = "${var.public_key_path}" zone = "${var.zone}"
}
db_disk_image
```
Используем команду для загрузки модулей. В директории terraform:
```
$ terraform get
```
Модули будут загружены в директорию .terraform, в которой уже содержится провайдер

Получаем output переменные из модуля

В созданном нами модуле app мы определили выходную переменную для внешнего IP инстанса. Чтобы получить значение этой переменной, переопределим ее
```
output "app_external_ip" {
value = "${module.app.app_external_ip}"
}
```
Самостоятельное задание

Аналогично предыдущим модулям создайте модуль vpc, в котором определите настройки файервола в рамках сети. Используйте созданный модуль в основной конфигурации terraform/main.tf
```
resource "google_compute_firewall" "firewall_ssh" {
  name    = "default-allow-ssh"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = "${var.source_ranges}"
}
```
Теперь мы можем задавать диапазоны IP адресов для правила файервола при вызове модуля. terraform/main.tf
```
...
module "vpc" {
source = "modules/vpc"
source_ranges = ["внешний ip"] }
```
Самостоятельное задание Проверьте работу параметризованного в прошлом слайде модуля vpc.

Введите в source_ranges не ваш IP адрес, примените правило и проверьте отсутствие соединения к обоим хостам по ssh. Проконтролируйте, как изменилось правило файрвола в веб консоли.
Нет доступа к хостам app и db в фильтрах измениля ip адрес

Введите в source_ranges ваш IP адрес, примените правило и проверьте наличие соединения к обоим хостам по ssh.
Верните 0.0.0.0/0 в source_ranges.
Переиспользование модулей

#### Создадим Stage & Prod

В директории terrafrom создайте две директории: stage и prod. Скопируйте файлы main.tf, variables.tf, outputs.tf, terraform.tfvars из директории terraform в каждую из созданных директорий. Поменяйте пути к модулям в main.tf на "../modules/xxx" вместо "modules/xxx".

Инфраструктура в обоих окружениях будет идентична, однако будет иметь небольшие различия: мы откроем SSH доступ для всех IP адресов в окружении Stage, а в окружении Prod откроем доступ только для своего IP.
```
terraform/stage/main.tf

provider "google" {
version = "1.4.0"
project = "${var.project}"
region  = "${var.region}"
}
module "app" {
source          = "../modules/app"
public_key_path = "${var.public_key_path}"
app_disk_image  = "${var.app_disk_image}"
}
module "db" {
source          = "../modules/db"
public_key_path = "${var.public_key_path}"
db_disk_image  = "${var.db_disk_image}"
}
module "vpc" {
source          = "../modules/vpc"
source_ranges = ["0.0.0.0/0"]
}
```
terraform/prod/main.tf
```
provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region  = "${var.region}"
}
module "app" {
  source          = "../modules/app"
  public_key_path = "${var.public_key_path}"
  app_disk_image  = "${var.app_disk_image}"
}
module "db" {
  source          = "../modules/db"
  public_key_path = "${var.public_key_path}"
  db_disk_image  = "${var.db_disk_image}"
}
module "vpc" {
  source          = "../modules/vpc"
  source_ranges = ["82.155.222.156/32"]
}
```
#### Работа с реестром модулей.

Давайте попробуем воспользоваться модулем storage-bucket для создания бакета в сервисе Storage.

Создайте в папке terraform файл

storage-bucket.tf с таким содержанием:
 ```
 provider "google" { version = "1.4.0"
project = "${var.project}" region = "${var.region}"
}
module "storage-bucket" {
source = "SweetOps/storage-bucket/google"
version = "0.1.1"
name = ["storage-bucket-test", "storage-bucket-test2"]
}
output storage-bucket_url {
value = "${module.storage-bucket.url}"
}
```
Работа с реестром модулей

Проверьте с помощью gsutil или веб консоли, что бакеты создались и доступны.
```
gsutil ls
gs://prod-storage-bucket/
gs://stage-storage-bucket/
```


### ДЗ №8 
Управление конфигурацией. Основные DevOps инструменты. Знакомство
с Ansible

Установка Ansible.
```
pip install -r requirements.txt
```
Проверяем, что Ansible установлен:
```
$ ansible --version
ansible 2.4.x.x
```
Поднимим инфраструктуру, описанную в окружении stage
```
$ terraform apply

app_external_ip = x.x.x.x
db_external_ip = x.x.x.x
```

Создаем инвентори файл ansible/inventory
```
appserver ansible_host=35.195.186.154 ansible_user=appuser \
ansible_private_key_file=~/.ssh/appuser
```
Проверяем что ansible управляет инстансом app
```
ansible appserver -i ./inventory -m ping
appserver | SUCCESS => {
"changed": false,
"ping": "pong"
}
```
и инстансом db
```
$ ansible dbserver -i inventory -m ping
dbserver | SUCCESS => {
"changed": false,
"ping": "pong"
}
```
Создадим конфигурационный ansible.cfg
```
[defaults]
inventory = ./inventory
remote_user = appuser
private_key_file = ~/.ssh/appuser
host_key_checking = False
retry_files_enabled = False
```   
Уберем из файла inventory информацию о ssh содинении
```
appserver ansible_host=35.195.74.54
dbserver ansible_host=35.195.162.174
```
Проверим работу
```
$ ansible dbserver -m command -a uptime
dbserver | SUCCESS | rc=0 >>
07:47:41 up 24 min, 1 user, load average: 0.00, 0.00, 0.03
```

Работа с групой хостов
меняем файл inventory 
```
[app] 
appserver ansible_host=35.195.74.54 
[db]
dbserver ansible_host=35.195.162.174
```

Проверяем работу
```
$ ansible app -m ping

appserver | SUCCESS => {
"changed": false,
"ping": "pong"
}
```
Использование YAML inventory
создаем файл  inventory.yml
```
cp inventory inventory.yml
```
Проверяем что работает с ключем -i которой определяет путь к inventory файлу
```
$ ansible all -m ping -i inventory.yml
dbserver | SUCCESS => {
"changed": false,
"ping": "pong"
}
appserver | SUCCESS => {
"changed": false,
"ping": "pong"
}
```
Выполнение команд
Проверим, что на app сервере установлены компоненты для
работы приложения (ruby и bundler):
```
$ ansible app -m command -a 'ruby -v'
appserver | SUCCESS | rc=0 >>
ruby 2.3.1p112 (2016-04-26) [x86_64-linux-gnu]
$ ansible app -m command -a 'bundler -v'
appserver | SUCCESS | rc=0 >>
Bundler version 1.11.2
```
Выполнение команд

Проверим, что на app сервере установлены компоненты для
работы приложения (ruby и bundler):

Попробуем указать две команды модулю command:
```
ansible app -m command -a 'ruby -v; bundler -v' -i inventory.yml
appserver | FAILED | rc=1 >>
ruby: invalid option -;  (-h will show valid options) (RuntimeError)non-zero return code
```

```
 ansible app -m shell -a 'ruby -v; bundler -v' -i inventory.yml
appserver | CHANGED | rc=0 >>
ruby 2.3.1p112 (2016-04-26) [x86_64-linux-gnu]
Bundler version 1.11.2
```
Модуль shell успешно отработает:

Проверим на хосте с БД статус сервиса MongoDB с помощью
модуля command или shell
```
ansible db -m command -a 'systemctl status mongod' -i inventory.yml
dbserver | CHANGED | rc=0 >>
● mongod.service - High-performance, schema-free document-oriented database
   Loaded: loaded (/lib/systemd/system/mongod.service; enabled; vendor preset: enabled)
   Active: active (running) since Mon 2018-11-05 18:33:32 UTC; 18min ago
     Docs: https://docs.mongodb.org/manual
 Main PID: 1273 (mongod)
    Tasks: 19
   Memory: 52.3M
      CPU: 6.673s
   CGroup: /system.slice/mongod.service
           └─1273 /usr/bin/mongod --quiet --config /etc/mongod.conf

Nov 05 18:33:32 reddit-db systemd[1]: Started High-performance, schema-free document-oriented database.
```
Пробуем с systemd
```
ansible db -m systemd -a name=mongod -i inventory.yml
dbserver | SUCCESS => {
    "changed": false,
    "name": "mongod",
    "status": {
        "ActiveEnterTimestamp": "Mon 2018-11-05 18:33:32 UTC",
        "ActiveEnterTimestampMonotonic": "16141469",
        "ActiveExitTimestampMonot,
         "ActiveState": "active",
...  
```
C помощью модуля service, который более
универсален и будет работать и в более старых ОС с init.dинициализацией:
```
dnvlasov@resero:~/dnvlasov_infra/ansible$ ansible db -m service -a name=mongod -i inventory.yml
dbserver | SUCCESS => {
    "changed": false,
    "name": "mongod",
    "status": {
        "ActiveEnterTimestamp": "Mon 2018-11-05 18:33:32 UTC",
        "ActiveEnterTimestampMonotonic": "16141469",
        "ActiveExitTimestampMonotonic": "0",
        "ActiveState": "active",
```
Напишем простой плейбук
```
- name: Clone
  hosts: app
  tasks:
  - name: Clone repo
    git: repo: https://github.com/express42/reddit.git
dest: /home/appuser/reddit
```
И выполним: ansible-playbook clone.yml
```
PLAY RECAP ***********************************************************************
appserver : ok=2 changed=0 unreachable=0 failed=0
```

```
 ansible app -m command -a 'rm -rf ~/reddit' -i inventory.yml
 [WARNING]: Consider using the file module with state=absent rather than running rm.  If you need to use command because file is
insufficient you can add warn=False to this command task or set command_warnings=False in ansible.cfg to get rid of this message.

appserver | CHANGED | rc=0 >>

```


### ДЗ №9
Деплой и управление конфигурацией с Ansible.
#### Плейбуки
- Создание плейбука
Создадим плейбук для управления конфигурацией
и деплоя нашего приложения. Для этого создайте
файл reddit_app.yml в директории ansible. 
добавим в файл .gitignore следующую
строку:  *.retry  
- Сценарий для монго

ansible/reddit_app.yml
```yml
---
- name: Configure hosts & deploy application
  hosts: all
  tasks:
   - name: Change mongo config file
     become: true
     template:
       src: templates/mongod.conf.j2
       dest: /etc/mongod.conf
       mode: 0644
       tags: db-tag

```
Для каждого из наших тасков будем определять тег, чтобы
иметь возможность запускать отдельные таски, имеющие
определенный тег, а не запускать таски все сразу. 
- Шаблон конфига MongoDB
В директории ansibe/templates создадим файл
mongod.conf.j2 
Вставим в данный шаблон параметризованный
конфиг для MongoDB 
```j2
# Where and how to store data.
storage:
  dbPath: /var/lib/mongodb
  journal:
    enabled: true

# where to write logging data.
systemLog:
  destination: file
  logAppend: true
  path: /var/log/mongodb/mongod.log

# network interfaces
net:
  port: {{ mongo_port | default('27017') }}
  bindIp: {{ mongo_bind_ip }}
  ```
- Пробный прогон
```bash
ansible-playbook reddit_app.yml --check --limit db
```
Видим ошибку: ```'mongo_bind_ip'``` is undefined"  переменная,
которая используется в шаблоне не определена
- Определение переменных
Определим значения переменных в нашем плейбуке
```yml
---
- name: Configure hosts & deploy application
  hosts: all
  vars:
    mongo_bind_ip: 0.0.0.0
  tasks:
    - name: Change mongo config file
      become: true
      template:
        src: templates/mongod.conf.j2
        dest: /etc/mongod.conf
        mode: 0644
        tags: db-tag
 ```
- Повторим проверку плейбука
```bash
 ansible-playbook reddit_app.yml --check --limit db
 ```
Проверка  прошла успешно
- Handlers
Handlers похожи на таски, однако запускаются
только по оповещению других тасков. Таск шлет
оповещение handler-у в случае, когда он меняет
свое состояние. По этой причине handlers удобно
использовать для перезапуска сервисов
- Добавим handlers

- ansible/reddit_app.yml
```yml
---
- name: Configure hosts & deploy application
  hosts: all
  vars:
    mongo_bind_ip: 0.0.0.0
  tasks:
   - name: Change mongo config file
     become: true
     template:
         src: templates/mongod.conf.j2
         dest: /etc/mongod.conf
         mode: 0644
         tags: db-tag
     notify: restart mongod
  handlers:
  - name: restart mongod
    become: true
    service: name=mongod state=restarted
 ```
 Применим плейбук
- Настройка инстанса приложения
Создадим директорию files внутри директории
ansible и добавьте туда файл puma.service файл. 
Добавим в наш сценарий таск для копирования unit файла на хост приложения. 
```yml
 tasks:
 - name: Change mongo config file
...
 - name: Add unit file for Puma
   become: true
   copy:
      src: files/puma.service
      dest: /etc/systemd/system/puma.service
      tags: app-tag
   notify: reload puma
 - name: enable puma
   become: true
  systemd: name=puma enabled=yes
  tags: app-tag
 ```
 Не забудем добавить новый handler, который
указывает systemd, что unit для сервиса изменился и
его следует перечитать
```yml
 handlers:
 - name: restart mongod
 become: true
 service: name=mongod state=restarted

 - name: reload puma
 become: true
 systemd: name=puma state=restarted 
 ```
  В unit файле добавим строку чтения
переменных окружения из файла:
```yml
EnvironmentFile=/home/appuser/db_config 
```
Создадим шаблон в директории ```templates/
db_config.j2``` куда добавим следующую строку: 
```yml
DATABASE_URL={{ db_host }}
```
Добавим таск для копирования созданного шаблона: 
```yml
- name: Add unit file for Puma
...
- name: Add config for DB connection
  template:
    src: templates/db_config.j2
    dest: /home/appuser/db_config
    tags: app-tag
- name: enable puma
  become: true
  systemd: name=puma enabled=yes
  tags: app-tag
 ```
 И не забудем определить переменную db_host
 ```yml
 ---
- name: Configure hosts & deploy application
  hosts: all
  vars:
    mongo_bind_ip: 0.0.0.0
    db_host: 10.132.0.2
  tasks:

```
Пробный прогон: 
```bash
$ ansible-playbook reddit_app.yml --check --limit
app --tags app-tag 
```
Применим наши таски плейбука с тегом app-tag для
группы хостов app:
```bash
$ ansible-playbook reddit_app.yml --limit app --tags
app-tag 
```
### Деплой
 Добавим еще несколько тасков в сценарий нашего
плейбука
Используем модули git и bundle для клонирования
последней версии кода нашего приложения и
установки зависимых гемов через bundle. 
ansible/reddit_app.yml

```yml
- name: Fetch the latest version of   application code
 git:
   repo:'https://github.com/express42/reddit.git'
   dest: /home/appuser/reddit
   version: monolith
   tags: deploy-tag
 notify: reload puma
 - name: Bundle install
   bundler:
    state: present
    chdir: /home/appuser/reddit
   tags: deploy-tag 
```
- Выполняем деплой
```bash
$ ansible-playbook reddit_app.yml --check --limit app --tags deploy-tag
$ ansible-playbook reddit_app.yml --limit app --tags deploy-tag 
```
Проверяем работу приложения
```ip_address:9292```

#### Один плейбук, несколько сценариев
 
 - Сценарий для MongoDB
 Создадим новый файл reddit_app2.yml в
директории ansible. Определим в нем несколько
сценариев (plays), в которые объединим задачи,
относящиеся к используемым в плейбуке тегам
- Определим отдельный сценарий для управления
конфигурацией MongoDB
```yml
---
- name: Configure hosts & deploy application
  hosts: all
  vars:
    mongo_bind_ip: 0.0.0.0
  tasks:
    - name: Change mongo config file
      become: true
      template:
        src: templates/mongod.conf.j2
        dest: /etc/mongod.conf
        mode: 0644
      tags: db-tag
      notify: restart mongod

  handlers:
  - name: restart mongod
    become: true
    service: name=mongod state=restarted
```
Изменим словесное описание, укажем нужную
группу хостов. Уберем теги из тасков и определим
тег на уровне сценария, чтобы мы могли запускать
сценарий, используя тег.
Вынесем   ```become: true```  на уровень сценария.
```yml
---
- name: Configure MongoDB
  hosts: db
  tags: db-tag
  become: true
  vars:
    mongo_bind_ip: 0.0.0.0
  tasks:
    - name: Change mongo config file
      template:
        src: templates/mongod.conf.j2
        dest: /etc/mongod.conf
        mode: 0644
      notify: restart mongod

  handlers:
  - name: restart mongod
    service: name=mongod state=restarted
```
#### Сценарий для App

Для настройки инстанса приложения
 пометим тегом app-tag. Вставим скопированную
информацию в reddit_app2.yml следом за сценарием для MongoDB.
```yml
- name: Configure App
  hosts: app
  tags: app-tag
  become: true
  vars:
    db_host: 10.132.0.2
  tasks:
   - name: Add unit file for Puma
    copy:
      src: files/puma.service
      dest: /etc/systemd/system/puma.service
    notify: reload puma
   - name: Add config for DB connection
     template:
        src: templates/db_config.j2
        dest: /home/appuser/db_config
        owner: appuser
        group: appuser
   - name: enable puma
     systemd: name=puma enabled=yes
  handlers:
   - name: reload puma
     systemd: name=puma state=restarted
```
- Пересоздадим инфраструктуру

```bash
$ terraform destroy
$ terraform apply -auto-approve=false
```
- Проверим работу сценариев
db-tag
```bash
$ ansible-playbook reddit_app2.yml --tags db-tag --check
$ ansible-playbook reddit_app2.yml --tags db-tag 
```
app-tag
```bash
$ ansible-playbook reddit_app2.yml --tags app-tag --check
$ ansible-playbook reddit_app2.yml --tags app-tag 
```
#### Сценарий для деплоя
```yml
- name: Deploy App
  hosts: app
  tags: deploy-tag
  tasks:
    - name: Fetch the latest version of application code
      git:
        repo: 'https://github.com/express42/reddit.git'
        dest: /home/appuser/reddit
        version: monolith
      notify: restart puma

    - name: bundle install
      bundler:
        state: present
        chdir: /home/appuser/reddit

  handlers:
  - name: restart puma
    become: true
    systemd: name=puma state=restarted
```
Проверка сценария 
```bash
 $ ansible-playbook reddit_app2.yml --tags deploy-tag --check
 $ ansible-playbook reddit_app2.yml --tags deploy-tag 
```
 проверка   ```  http://ip_address:9292```

### cd 
В директории ansible создадим три новых файла app.yml, db.yml, deploy.yml. 
mkdir {app,db,deploy}.yml
Заодно переименуем наши предыдущие плейбуки:
- reddit_app.yml -> reddit_app_one_play.yml
- reddit_app2.yml-> reddit_app_multiple_plays.yml

Из файла reddit_app_multiple_plays.yml скопируем
сценарий, относящийся к настройке БД, в файл
db.yml, удалим тег определенный в сценарии.

#### db.yml 
```yml
---
- name: Configure MongoDB
  hosts: db
  become: true
  vars:
     mongo_bind_ip: 0.0.0.0
  tasks:
    - name: Change mongo config file
      template:
          src: templates/mongod.conf.j2
          dest: /etc/mongod.conf
          mode: 0644
      notify: restart mongod
  handlers:
  - name: restart mongod
    service: name=mongod state=restarted
```
#### app.yml
```yml
---
- name: Configure App
  hosts: app
  tags: app-tag <-- удалить tag
  become: true
  vars:
    db_host: 10.132.0.2
  tasks:
   - name: Add unit file for Puma
       copy:
       src: files/puma.service
       dest: /etc/systemd/system/puma.service
     notify: reload puma
   - name: Add config for DB connection
    template:
        src: templates/db_config.j2
        dest: /home/appuser/db_config
        owner: appuser
        group: appuser
   - name: enable puma
    systemd: name=puma enabled=yes
  handlers:
   - name: reload puma
   systemd: name=puma state=restarted
 ```
 #### deploy.yml
 ```yml
 - name: Deploy App
  hosts: app
  tasks:
    - name: Fetch the latest version of application code
      git:
        repo: 'https://github.com/express42/reddit.git'
        dest: /home/appuser/reddit
        version: monolith
      notify: restart puma

    - name: bundle install
      bundler:
        state: present
        chdir: /home/appuser/reddit

  handlers:
  - name: restart puma
    become: true
    systemd: name=puma state=restarted
```
Создадим файл site.yml в директории ansible, в котором
опишем управление конфигурацией всей нашей
инфраструктуры. Это будет нашим главным плейбуком,
который будет включать в себя все остальные
#### site.yml
```yml
---
- import_playbook: db.yml
- import_playbook: app.yml
- import_playbook: deploy.yml 
```
#### Пересоздадим инфраструктуру
Исрользуем окружение stage
```bash
$ terraform destroy
$ terraform apply -auto-approve=false
```
#### Проверим работу плейбуков
```bash
$ ansible-playbook site.yml --check
$ ansible-playbook site.yml
```
#### Проверим работу приложения
http://ip_address:9292

### Изменим провижининг в Packer

Создадим  плейбуки
ansible/packer_app.yml 

```
---
- name: Install Ruby && Bundler
  hosts: all
  become: true
  tasks:
    - name: Install ruby and rubygems and required packages
      apt: "name={{ item }} state=present"
      with_items:
           - ruby-full
           - ruby-bundler
           - build-essential
```
ansible/packer_db.yml.
```
---
- name: Install MongoDB 3.2
  hosts: all
  become: true
  tasks:
    - name: Add APT key
      apt_key:
         id: EA312927
         keyserver: keyserver.ubuntu.com

    - name: Add APT repository
      apt_repository:
         repo: deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse
         state: present

    - name: Install mongodb package
      apt:
       name: mongodb-org
       state: present

    - name: Configure service supervisor
      systemd:
       name: mongod
       enabled: yes
```
#### Интегрируем Ansible в Packer
Заменим секцию Provision в образе packer/app.json на Ansible 
```json
{
          "provisioners": [
              {
              "type": "ansible",
              "playbook_file":"ansible/packer_app.yml"
              }
       ]
}
```
Такие же изменения выполним и для packer/db.json
```json
{
    
      "provisioners": [
              {
              "type": "ansible",
              "playbook_file":"ansible/packer_db.yml"
          }
       ]
}
```
Соберем образы 
db и app
```bash
packer build  -var-file=packer/variables.json  packer/db.json

packer build  -var-file=packer/variables.json  packer/app.json
```

### ДЗ №10
#### Ansible: работа с ролями и окружениями.
- Создадим роли 
```bash
ansible-galaxy init roles/app
ansible-galaxy init roles/db
```
Структура диектории  созданной  роли db
```
$tree db

db
├── defaults          # <-- Диектория для переменных по умолчанию
│   └── main.yml
├── files
├── handlers
│   └── main.yml
├── meta              # <-- Информация о роли, создателе и зависимостях
│   └── main.yml
├── README.md
├── tasks             # <-- Директоря для тасков
│   └── main.yml
├── templates
│   └── mongod.conf.j2
├── tests
│   ├── inventory   
│   └── test.yml
└── vars              # <-- Директория для переменных, которые не должны 
    └── main.yml      #     переопределятся пользователем

6 directories, 8 files
```

- Скопируем  секцию tasks в сценарии плейбука ansible/db.yml
и вставим в ее в файл в директории tasks роли db
```yml
Файл ansible/roles/db/tasks/main.yml

---
# tasks file for db
- name: Show info about the env this host belongs to
  debug: msg="This host is in {{ env }} environment!!!"

- name: Change mongo config file
  template:
      src: mongod.conf.j2
      dest: /etc/mongod.conf
      mode: 0644
  notify: restart mongod

```
Определяем хендлер в директории handlers роли
```yml
# handlers file for db
- name: restart mongod
  service: name=mongod state=restarted
```
Определим используеме в шаблоне переменные в секции переменных по умолчанию (файл
ansible/roles/db/defaults/main.yml)
```yml
# defaults file for db
mongo_port: 27017
mongo_bind_ip: 127.0.0.1
```
#### Роль для приложения
- Выполним команду ansible-galaxy init в папке roles/app
- Скопируем в секцию tasks сценарий плейбука ansible/app.yml
```yml
ansible/roles/app/tasks/main.yml

# tasks file for app
- name: Add unit file for Puma
  copy:
    src: puma.service 
    dest: /etc/systemd/system/puma.service
  notify: reload puma

- name: Add config for DB connection
  template:
      src: db_config.j2
      dest: /home/appuser/db_config
      owner: appuser
      group: appuser
- name: enable puma
  systemd: name=puma enabled=yes
```
- Скопируем db_config.j2 из директории
ansible/templates в директорию 
ansible/roles/app/templates
- Файлы ansible/files/puma.service в
ansible/roles/app/files
- Опишим хендлер соответствующий директории app
```yml
ansible/role/app/handlers/main.yml
---
# handlers file for app
- name: reload puma
  systemd: name=puma state=restarted
```
Также определим переменную по умолчанию подключения к MongoDB
```yml
ansible/role/app/defaults/main.yml  
---
# defaults file for app
db_host: 127.0.0.1
env: local
```
Удалим определение тасков и хендлеров в плейбуке ansible/app.yml
```yml
---
- name: Configure App
  hosts: app
  become: true
  vars:
    db_host: 10.140.0.2
  roles:
    - app  
 
```
Пересоздадим окружение stage terraform
```bash
terraform destroy
terraform apply --auto-approve=false
```

Запустим плейбуки
```bash
./d_invent.sh site.yml --check
./d_invent.sh site.yml 
```

Проверим работу приложения
`http://ip_address:9292`

#### Окружение

- Определим окружение по умолчанию
```yml

[defaults]
inventory = ./environments/stage/inventory
remote_user = appuser
private_key_file = ~/.ssh/appuser
host_key_checking = False
```
Ansible позволяет задавать  переменные для группы хостов.
директория group_vars позволяет создавать файлы (имена, которых
должны соответствовать названиям групп в инвентори файле) для
определения переменных для группы хостов.
- Создадим директорию group_vars в директориях наших
окружений `nvironments/prod` и `environments/stage`.
#### Конфигурация Stage
- Зададим настройки окружения stage, используя групповые
переменные:
1. Создадим файлы `stage/group_vars/app` для определения
переменных для группы хостов app, описанных в инвентори
файле `stage/inventory`
2. Скопируем в этот файл переменные, определенные в плейбуке
`ansible/app.yml.`
3. Также удалим определение переменных из самого плейбука
`ansible/app.yml.`

- Аналогичным образом определим переменные для группы
хостов БД на окружении stage:

1. Создадим файл `stage/group_vars/db` и скопируем в него
содержимое переменные из плейбука `ansible/db.yml`
2. Секцию определения переменных из самого плейбука
`ansible/db.yml` удалим.

- Создайте файл `ansible/environments/stage/group_vars/all`
со следующим содержимым:
```yml
env: stage
```
#### Конфигурация Prod
1. Для настройки окружения prod скопируйте файлы app, db, all из
директории stage/group_vars в директорию prod/group_vars.
2. В файле prod/group_vars/all измените значение env
переменной на prod
```yml
env: prod
```
#### Вывод информации об окружении
Для роли app в файле `ansible/roles/app/defaults/main.yml`:
```yml
---
# defaults file for app
db_host: 127.0.0.1
env: local
```

Для роли db в файле `ansible/roles/db/defaults/main.yml`:
```yml
---
# defaults file for db
mongo_port: 27017
mongo_bind_ip: 127.0.0.1
env: local
```

#### Вывод информации об окружении
Будем выводить информацию о том, в каком окружении
находится конфигурируемый хост. Воспользуемся модулем debug
для вывода значения переменной. Добавим следующий таск в
начало наших ролей.
- Для роли app (файл `ansible/roles/app/tasks/main.yml`):
```yml
---
# tasks file for app
- name: Show info about the env this host belongs to
  debug:
    msg: "This host is in {{ env }} environment!!!"
```
Добавим такой же таск в роль db (файл `ansible/roles/db/tasks/main.yml`)
```yml
---
# tasks file for db
- name: Show info about the env this host belongs to
  debug: msg="This host is in {{ env }} environment!!!"
```

#### Улучшим файл ansible.cfg
```cfg
[defaults]
inventory = ./environments/stage/inventory
remote_user = appuser
private_key_file = ~/.ssh/appuser
host_key_checking = False
retry_files_enabled = False
roles_path = ./roles
vault_password_file = ~/.ansible/vault.key
[diff]
always = True
context = 5
```
#### Проверка работы с окружениями
Для проверки пересоздадим инфраструктуру окружения stage,
используя команды:
```bash
$ terraform destroy
$ terraform apply -auto-approve=false
```
Теперь запустим Ansible...
```bash
$ ./d_invent.sh playbooks/site.yml --check
$ ./d_invent.sh playbooks/site.yml
```
Проверим работу приложения
`ip_address:9292`

### Настройка Prod окружения
