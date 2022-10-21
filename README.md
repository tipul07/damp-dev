# Introduction 

Docker Apache-MySQL-PHP dev environment 

# Getting Started
1. After pulling docker files, run `_setup.bat`.
2. Do `docker-compose up -d` which will download and build your images

# MySQL Setup
1. Dump your database from where it is now using `mysqldump -u {MySQLUser} -p {OldDatabaseName} > {OldDatabaseName}.sql`
2. Make sure your containers are started `docker-compose up -d`
3. Do `docker exec -it mysql bash`
4. Do `mysql -u {DockerMySQLUser} -p {DockerMySQLDatabase} < {OldDatabaseName}.sql`
5. You should see `mysql/{DockerMySQLDatabase}` directory populated

# Testing PHP - MySQL connection
1. Open browser and go to `http://127.0.0.1/`
2. You should see `Connected successfully`
3. Once all is ok, you can copy project files in `src` directory.

# PHPMyAdmin
1. For database management, you can use `phpmyadmin` image by opening `http://127.0.0.1:8081/` in browser.
2. In order to login, you should use: Username `root`, Password the password used in `docker-compose.yml` file (under `services.mysql.environment.MYSQL_ROOT_PASSWORD`). Default: `password`

# Project Files Setup
1. Project files should be copied to `src/` directory (`index.php` file which is the entry point of the project should be located in `src/` directory)
2. `src/` directory will be mounted on both `web` and `php` docker images in `/srv/www`
3. Do `docker exec -it php bash` and make sure all symlinks in the project are updated to match the new paths.
4. To test working copy is ok, open browser and go to `http://127.0.0.1/`.

# Xdebug
1. After running `_setup.bat`, you will see `files/config/xdebug/xdebug.ini` file which you can customize however you want (it is not linked with files in git).
2. Important to notice is `xdebug.idekey=PHPSTORM` which should be changed (or not depending on Xdebug key setup in PhpStorm)
3. If you didn't change anything in `_setup.bat` you can ignore this point. `xdebug.client_host=172.22.0.1` is the gateway IP of `devnet` bridge network created in `_setup.bat` script. If you change IP class for this subnet, you should change this IP in default gateway of the bridge subnet created for docker images.

# Cron jobs
1. If there are any cronjobs required in the php docker image, they can be added in `files/in_docker/cron.txt`
2. `files/in_docker/cron.txt` file becomes available only after running `_setup.bat` file.
