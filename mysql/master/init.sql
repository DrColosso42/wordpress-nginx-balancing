CREATE USER 'repl1'@'%' IDENTIFIED WITH mysql_native_password BY 'replpwd';
GRANT REPLICATION SLAVE ON *.* TO 'repl1'@'%';
FLUSH PRIVILEGES;
