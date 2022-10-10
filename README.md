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
1. Open browser and go to `http://127.0.0.1:8080/`
2. You should see `Connected successfully`
3. Once all is ok, you can copy project files in `src` directory.

# Project Files Setup
1. Project files should be copied to `src/` directory (`index.php` file which is the entry point of the project should be located in `src/` directory)
2. `src/` directory will be mounted on both `web` and `php` docker images in `/srv/www`
3. Do `docker exec -it php bash` and make sure all symlinks in the project are updated to match the new paths.
4. To test working copy is ok, open browser and go to `http://127.0.0.1:8080/`.

# PHPMyAdmin
1. For database management, you can use `phpmyadmin` image by opening `http://127.0.0.1:8081/` in browser.
2. In order to login, you should use: Username `root`, Password the password used in `docker-compose.yml` file (under `services.mysql.environment.MYSQL_ROOT_PASSWORD`)