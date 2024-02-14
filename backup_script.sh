#!/bin/bash

# Configuration
read -p "Where to backup?: " backup_dir
read -p "Which files need to backup?: " backup_file

mysql_user="root"
mysql_password=""
postgres_user="postgres"
postgres_password="123456"
mongodb_host="localhost"
mongodb_port="27017"

# Create a timestamp for the backup
timestamp=$(date +"%Y%m%d_%H%M%S")

# Create backup directory if it doesn't exist
mkdir -p "$backup_dir"

# Backup files
files_backup_filename="files_backup_$timestamp.tar.gz"
tar -czf "$backup_dir/$files_backup_filename" "$backup_file"

# Backup MySQL databases
mysql_backup_filename="mysql_backup_$timestamp.sql"
sudo mysqldump -u "$mysql_user" -p"$mysql_password" --all-databases >"$backup_dir/$mysql_backup_filename"

if [ $? -eq 0 ]; then
    echo "MySQL backup completed successfully: $mysql_backup_filename"
else
    echo "Error: MySQL backup failed."
    exit 1
fi

# Backup PostgreSQL databases
postgres_backup_filename="postgres_backup_$timestamp.sql"
pg_dumpall -U "$postgres_user" -h localhost -w -f "$backup_dir/$postgres_backup_filename"

if [ $? -eq 0 ]; then
    echo "PostgreSQL backup completed successfully: $postgres_backup_filename"
else
    echo "Error: PostgreSQL backup failed."
    exit 1
fi

# Backup MongoDB databases
mongodb_backup_filename="mongodb_backup_$timestamp.tar.gz"
mongodump --host "$mongodb_host" --port "$mongodb_port" --out "$backup_dir/mongodb_dump"
tar -czf "$backup_dir/$mongodb_backup_filename" -C "$backup_dir" mongodb_dump

if [ $? -eq 0 ]; then
    echo "MongoDB backup completed successfully: $mongodb_backup_filename"
else
    echo "Error: MongoDB backup failed."
    exit 1
fi

# Optional: Clean up old backups (e.g., keep only the last 7 days)
find "$backup_dir" -type f -name "mysql_backup_*" -mtime +7 -delete
find "$backup_dir" -type f -name "postgres_backup_*" -mtime +7 -delete
find "$backup_dir" -type f -name "mongodb_backup_*" -mtime +7 -delete

echo "Backup process completed successfully."
