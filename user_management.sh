#!/bin/bash

# User Account Management Script

# Function to display usage information
display_usage() {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  -c, --create   Create a new user account."
    echo "  -cg, --create_group   Create a new group."
    echo "  -lg, --list_group   List all users on the group."
    echo "  -mg, --modify_group   Add multiple users in a group."
    echo "  -d, --delete   Delete an existing user account."
    echo "  -r, --reset    Reset the password of an existing user account."
    echo "  -m, --modify   Modify a user group."
    echo "  -l, --list     List all user accounts on the system."
    echo "  -h, --help     Display this help message."
}

# Function to create a new user account
create_user() {
    read -p "Enter the new username: " username

    # Check if the username already exists
    if id "$username" &>/dev/null; then
        echo "Error: Username '$username' already exists. Please choose a different username."
        exit 1
    fi

    # Prompt for password
    read -s -p "Enter the password: " password
    echo -e "\n"

    # Create the user
    sudo useradd -m -p "$(openssl passwd -1 "$password")" "$username"

    echo "Success: User '$username' created."
}

# Function to modify a user account
modify_user() {
    read -p "Enter the group name: " group
    read -p "Enter the new username: " username

    # Check if the username already exists
    if id "$username" &>/dev/null; then
        # Check if the user is already in the specified group
        if groups "$username" | grep -q "\<$group\>"; then
            echo "Error: User '$username' is already in the '$group' group."
            exit 1
        fi
    else
        echo "Error: User '$username' does not exist."
        exit 1
    fi

    # Update the user group
    sudo usermod -aG "$group" "$username"

    echo "Success: User '$username' added to the '$group' group."
}

# Function to delete an existing user account
delete_user() {
    read -p "Enter the username to delete: " username

    # Check if the username exists
    if id "$username" &>/dev/null; then
        sudo userdel -r "$username"
        echo "Success: User '$username' deleted."
    else
        echo "Error: Username '$username' does not exist."
        exit 1
    fi
}

# Function to reset the password of an existing user account
reset_password() {
    read -p "Enter the username to reset password: " username

    # Check if the username exists
    if id "$username" &>/dev/null; then
        read -s -p "Enter the new password: " new_password
        echo -e "\n"

        # Reset the password
        sudo usermod -p "$(openssl passwd -1 "$new_password")" "$username"

        echo "Success: Password for user '$username' reset."
    else
        echo "Error: Username '$username' does not exist."
        exit 1
    fi
}

# Function to list all user accounts on the system
list_users() {
    echo "List of User Accounts:"
    cut -d: -f1,3 /etc/passwd | column -t
}

# Function to create a new group
create_group() {
    read -p "Enter the group name: " group_name

    # Check if the group already exists
    if grep -q "^$group_name:" /etc/group; then
        echo "Error: Group '$group_name' already exists."
    else
        sudo groupadd "$group_name"
        echo "Success: Group '$group_name' created."
    fi
}

# Function to add users to a group
add_users_to_group() {
    read -p "Enter the group name: " group_name
    read -p "Enter the comma-separated list of usernames to add to the group: " user_list

    # Check if the group exists
    if grep -q "^$group_name:" /etc/group; then
        IFS=',' read -ra users <<<"$user_list"
        for user in "${users[@]}"; do
            # Check if the user exists
            if id "$user" &>/dev/null; then
                sudo usermod -aG "$group_name" "$user"
                echo "Success: User '$user' added to the group '$group_name'."
            else
                echo "Error: User '$user' does not exist."
            fi
        done
    else
        echo "Error: Group '$group_name' does not exist."
    fi
}

# Function to list users in a group
list_users_in_group() {
    read -p "Enter the group name: " group_name

    # Check if the group exists
    if grep -q "^$group_name:" /etc/group; then
        users=$(getent group "$group_name" | cut -d: -f4)
        if [ -z "$users" ]; then
            echo "No users in the group '$group_name'."
        else
            echo "Users in the group '$group_name': $users"
        fi
    else
        echo "Error: Group '$group_name' does not exist."
    fi
}

# Check if there are no arguments provided
if [ $# -eq 0 ]; then
    display_usage
    exit 1
fi

# Parse command-line options
while [ "$#" -gt 0 ]; do
    case "$1" in
    -c | --create)
        create_user
        ;;
    -d | --delete)
        delete_user
        ;;
    -r | --reset)
        reset_password
        ;;
    -m | --modify)
        modify_user
        ;;
    -cg | --create_group)
        create_group
        ;;
    -mg | --modify_group)
        add_users_to_group
        ;;
    -lg | --list_group)
        list_users_in_group
        ;;
    -l | --list)
        list_users
        ;;
    -h | --help)
        display_usage
        exit 0
        ;;
    *)
        echo "Error: Unknown option '$1'."
        display_usage
        exit 1
        ;;
    esac
    shift
done

exit 0
