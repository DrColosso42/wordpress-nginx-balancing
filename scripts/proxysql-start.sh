#!/usr/bin/env bash
set -euo pipefail

: "${MASTER_HOST:=db-master}"
: "${SLAVE_HOST:=db-slave}"
: "${MONITOR_USER:=monitor}"
: "${MONITOR_PASS:=monitorpass}"
: "${MYSQL_USER:?wpuser}"
: "${MYSQL_PASSWORD:?userpwd}"

cat >/etc/proxysql.cnf <<EOF
datadir="/var/lib/proxysql"

admin_variables = {
  admin_credentials="admin:admin"
  mysql_ifaces="0.0.0.0:6032"
}

mysql_variables = {
  threads=2
  max_connections=2048
  default_hostgroup=10
  monitor_username="${MONITOR_USER}"
  monitor_password="${MONITOR_PASS}"
  mysql-writers_hostgroups=10
  mysql-readers_hostgroups=20
  mysql_replication_hostgroups="10:20"
  interfaces="0.0.0.0:6033"
}

mysql_servers = (
  { address="${MASTER_HOST}", port=3306, hostgroup=10, max_connections=200, weight=1 },
  { address="${SLAVE_HOST}",  port=3306, hostgroup=20, max_connections=200, weight=1 }
)

mysql_users = (
  { username="${MYSQL_USER}", password="${MYSQL_PASSWORD}", default_hostgroup=10, transaction_persistent=true, active=1 }
)

mysql_query_rules = (
  { rule_id=10, active=1, match_pattern="^SELECT.*FOR UPDATE", destination_hostgroup=10, apply=1 },
  { rule_id=11, active=1, match_pattern="^SELECT.*LOCK IN SHARE MODE", destination_hostgroup=10, apply=1 },
  { rule_id=20, active=1, match_pattern="^SELECT", destination_hostgroup=20, apply=1 }
)
EOF

exec proxysql -f -c /etc/proxysql.cnf
