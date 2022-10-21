@echo off
echo Setting up repository...

if not exist files\config\xdebug\xdebug.ini (
    copy files\config\xdebug\xdebug.dist.ini files\config\xdebug\xdebug.ini
)

if not exist files\in_docker\cron.txt (
    copy files\in_docker\cron.dist.txt files\in_docker\cron.txt
)

mkdir src

if not exist src\index.php (
    copy files\index.php src\index.php
)
if not exist logs\index.html (
    copy files\index.html src\index.html
)

if not exist .env (
    copy .env.dist .env
)

echo Setting up bridge network...

docker network create --driver bridge --subnet 172.22.0.0/24 --gateway 172.22.0.1 devnet

echo DONE
echo You can run now docker-compose up -d
