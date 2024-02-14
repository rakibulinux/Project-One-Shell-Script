# User Management Script

Follow this link for user management: [User Management Script](https://www.rakibulinux.com/blogs/simplifying-user-management-on-linux-with-a-bash-script)

A simple Bash script for managing user accounts and groups on a Linux system. This script provides options to create, modify, delete user accounts, and manage groups effectively.

## Usage

```bash
./usermanagement.sh [options]
```

### Options

- **-c, --create:** Create a new user account.
- **-cg, --create_group:** Create a new group.
- **-lg, --list_group:** List all users in a group.
- **-mg, --modify_group:** Add multiple users to a group.
- **-d, --delete:** Delete an existing user account.
- **-r, --reset:** Reset the password of an existing user account.
- **-m, --modify:** Modify a user's group.
- **-l, --list:** List all user accounts on the system.
- **-h, --help:** Display this help message.

## Functions

### Create a New User Account

```bash
./usermanagement.sh -c
```

### Create a New Group

```bash
./usermanagement.sh -cg
```

### List Users in a Group

```bash
./usermanagement.sh -lg
```

### Add Users to a Group

```bash
./usermanagement.sh -mg
```

### Delete a User Account

```bash
./usermanagement.sh -d
```

### Reset User Password

```bash
./usermanagement.sh -r
```

### Modify User's Group

```bash
./usermanagement.sh -m
```

### List All User Accounts

```bash
./usermanagement.sh -l
```

### Help

```bash
./usermanagement.sh -h
```

## Notes

- The script ensures proper error handling and provides clear success or error messages for each operation.
- Make sure to run the script with appropriate privileges, especially for user-related operations.

Feel free to customize and extend the script based on your specific requirements and system configurations.

# Backup Script

Follow this link: [BackupScript](https://www.rakibulinux.com/blogs/complete-guide-to-linux-backup-how-to-backup-system-files-and-databases)
