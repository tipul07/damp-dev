@echo off
echo Setting up repository...

if not exist logs\php-access.log (
    copy logs\php-access.dist.log logs\php-access.log
) 
if not exist logs\php-error.log (
    copy logs\php-error.dist.log logs\php-error.log
) 

if not exist src\index.php (
    copy files\index.php src\index.php
)
if not exist logs\index.html (
    copy files\index.html src\index.html
)

mkdir src

echo DONE
