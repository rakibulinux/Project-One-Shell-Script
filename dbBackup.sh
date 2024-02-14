#!/bin/bash

# Configuration
read -p "Where to backup?: " backup_dir
read -p "Which files need to backup?: " backup_file
read -p "Enter the database type (mysql/postgres/mongodb): " db_type

case "$db_type" in
mysql)
    read -p "Enter MySQL username: " db_user
    read -s -p "Enter MySQL password: " db_password
    ;;
postgres)
    read -p "Enter PostgreSQL username: " db_user
    read -s -p "Enter PostgreSQL password: " db_password
    ;;
mongodb)
    read -p "Enter MongoDB host: " mongodb_host
    read -p "Enter MongoDB port: " mongodb_port
    ;;
*)
    echo "Error: Unsupported database type. Supported types are mysql, postgres, mongodb."
    exit 1
    ;;
esac

# Create a timestamp for the backup
timestamp=$(date +"%Y%m%d_%H%M%S")

# Create backup directory if it doesn't exist
mkdir -p "$backup_dir"

if [ $? -eq 0 ]; then
    echo "Files backup completed successfully: $files_backup_filename"
else
    echo "Error: Files backup failed."
    exit 1
fi

# Backup databases based on the specified type
case "$db_type" in
mysql)
    db_backup_filename="mysql_backup_$timestamp.sql"
    mysqldump -u "$db_user" -p"$db_password" --all-databases >"$backup_dir/$db_backup_filename"
    ;;
postgres)
    db_backup_filename="postgres_backup_$timestamp.sql"
    pg_dumpall -U "$db_user" -h localhost -w -f "$backup_dir/$db_backup_filename"
    ;;
mongodb)
    db_backup_filename="mongodb_backup_$timestamp.tar.gz"
    mongodump --host "$mongodb_host" --port "$mongodb_port" --out "$backup_dir/mongodb_dump"
    tar -czf "$backup_dir/$db_backup_filename" -C "$backup_dir" mongodb_dump
    ;;
esac

if [ $? -eq 0 ]; then
    echo "$db_type database backup completed successfully: $db_backup_filename"
else
    echo "Error: $db_type database backup failed."
    exit 1
fi

# Optional: Clean up old backups (e.g., keep only the last 7 days)
find "$backup_dir" -type f -name "files_backup_*" -mtime +7 -delete
find "$backup_dir" -type f -name "$db_type*_backup_*" -mtime +7 -delete

echo "Backup process completed successfully."
