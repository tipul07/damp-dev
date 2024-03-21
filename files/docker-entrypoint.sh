#!/bin/bash
set -e

username="www-data"

host_dir="/from_host"
script_debugging_mode=0

log_file="$host_dir/logs/_log.txt"
cmd_file="$host_dir/logs/_commands.txt"

# This variable is used when we need exit code of last evaluated command
cmdres=""

##############################
# Script functions
do_logf () {

  also_echo="$2"
  if [ -z "$2" ]; then also_echo="1"; elif [ "$2" != "1" ]; then also_echo="0"; fi

  echonl="$3"
  if [ -z "$3" ]; then echonl="1"; elif [ "$3" != "1" ]; then echonl="0"; fi

  if [ "$echonl" = "1" ]; then
    if [ "$also_echo" = "1" ]; then echo "$1"; fi

    echo "$1" >> "$log_file"
  else
    if [ "$also_echo" = "1" ]; then echo -n "$1"; fi

    echo -n "$1" >> "$log_file"
  fi
}

cmd_logf () {
  echo "$1" >> "$cmd_file"
}

eval_cmd() {

  also_log="$2"
  if [ -z "$2" ]; then also_log="1"; elif [ "$2" != "1" ]; then also_log="0"; fi

  if [ "$also_log" = "1" ]; then cmd_logf "$1"; fi

  if [ "$script_debugging_mode" = "1" ]; then ev_cmd="echo \"$1\" > /dev/null"; else ev_cmd="$1"; fi

  eval "$ev_cmd;cmdres=\$?"
}

trim_str() {
  local trimmed_str
  trimmed_str="$(echo -e "$1" | sed -e 's/^\s*//' -e 's/\s*$//')"
  echo "$trimmed_str"
}
# END Script functions
##############################

# PHP-FPM version to start
php_fpm_ver="8.1"
if [ -n "$2" ]; then
  php_fpm_ver="$2"
fi

if [ "$1" = 'php-fpm' ]; then

  # Clean log files...
  echo -n "" > "$log_file"
  echo -n "" > "$cmd_file"

  do_logf "PHP $php_fpm_ver, Debugging mode [$script_debugging_mode], Started at $(date)"

  # Clean pools to be sure only desired pools are created...
  eval_cmd "rm -f /etc/php/${php_fpm_ver}/fpm/pool.d/*"

  # Make sure we have /run/php dir
  eval_cmd "[ -d /run/php ] || mkdir /run/php"

  # Check crontab file...
  if [ -f "$host_dir/cron.txt" ] && [ -r "$host_dir/cron.txt" ]; then

    do_logf "Installing cronfile... " 1 0

    cron_cmd="crontab -u ${username} $host_dir/cron.txt"
    eval_cmd "$cron_cmd"
    if [ $cmdres -ne 0 ]; then
      do_logf "ERROR: Couldn't install cron file."
    fi
  fi
  # END Check crontab file...

  # Add PHP-FPM pool...
  if [ ! -f "$host_dir/pools/template_${php_fpm_ver}.conf" ] || [ ! -r "$host_dir/pools/template_${php_fpm_ver}.conf" ]; then
      do_logf "Skipped pool creation."
  else
      pool_file="/etc/php/${php_fpm_ver}/fpm/pool.d/${username}.conf"
      do_logf "Creating pool file... " 1 0

      # Create files only when running in container...
      if [ "$script_debugging_mode" != "1" ]; then
        {
          echo ""
          echo "; Generated at $(date)"
          echo "; THIS FILE IS AUTOGENERATED. IT WILL BE OVERWRITTEN ON NEXT CONTAINER RESTART..."
          echo "[$username]"
          echo ""
          cat "${host_dir}/pools/template_${php_fpm_ver}.conf"
        } > "$pool_file"
      fi

  fi
  # END Add PHP-FPM pool...

  # Create PHP-FPM log files...
  do_logf "Log files... " 1 0
  touch "/var/log/php-fpm/$username.access.log"
  touch "/var/log/php-fpm/$username.error.log"
  touch "/var/log/php-fpm/$username.slow.log"

  chown $username.$username /var/log/php-fpm/$username.*
  # END Create PHP-FPM log files...

  do_logf "DONE"

  echo "Restarting services..."
  service cron restart
  #service supervisor start
  echo "DONE"

  eval "/usr/sbin/php-fpm${php_fpm_ver} --nodaemonize --fpm-config /etc/php/${php_fpm_ver}/fpm/php-fpm.conf --pid /run/php${php_fpm_ver}-fpm.pid"

fi

exec "$@"
