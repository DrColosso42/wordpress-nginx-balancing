#!/usr/bin/env bash

set -euo pipefail

HOST=${MASTER_HOST:-db-master}
USER=${REPL_USER}
PASS=${REPL_PASS}

echo "Ucitavanje master baze"
until mysqladmin ping -h "$HOST" --silent; do sleep 2; done

FILE=$(mysql -h "$HOST" -uroot -p"$MYSQL_ROOT_PASSWORD" -e "SHOW MASTER STATUS\G" | awk '/File:/ {print $2}')
POS=$(mysql -h "$HOST" -uroot -p"$MYSQL_ROOT_PASSWORD" -e "SHOW MASTER STATUS\G" | awk '/Position:/ {print $2}')

mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -e "STOP SLAVE; RESET SLAVE ALL;
  CHANGE REPLICATION SOURCE TO
  SOURCE_HOST='$HOST',
  SOURCE_USER='$USER',
  SOURCE_PASSWORD='$PASS',
  SOURCE_LOG_FILE='$FILE',
  SOURCE_LOG_POS=$POS,
  GET_SOURCE_PUBLIC_KEY=1;

  START SLAVE;"

