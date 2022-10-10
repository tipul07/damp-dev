@echo off
echo Setting up repository...

rem if not exist logs\php-access.log (
rem     copy logs\php-access.dist.log logs\php-access.log
rem )
rem if not exist logs\php-error.log (
rem     copy logs\php-error.dist.log logs\php-error.log
rem )

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

echo DONE
echo You can run now docker-compose up -d
