docker exec -it proxysql mysql -h127.0.0.1 -P6032 -uadmin -padmin -e "SELECT hostgroup_id,hostname,status FROM mysql_servers;";

docker exec -it proxysql mysql -h127.0.0.1 -P6032 -uadmin -padmin -e "SELECT rule_id,match_pattern,destination_hostgroup,active FROM mysql_query_rules;";
