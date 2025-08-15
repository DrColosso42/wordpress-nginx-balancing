CREATE USER 'repl1'@'%' IDENTIFIED WITH mysql_native_password BY 'replpwd';
GRANT REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'repl1'@'%';

CREATE USER IF NOT EXISTS 'monitor'@'%' IDENTIFIED WITH mysql_native_password BY 'monitorpass';
GRANT USAGE, REPLICATION CLIENT ON *.* TO 'monitor'@'%';
FLUSH PRIVILEGES;
