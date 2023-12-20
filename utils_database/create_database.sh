#!/bin/bash
create_database() {
    while true; do
        read -p "Please enter database name to create: " db_name
        if [[ -z "$db_name" ]]; then
            echo "Database name cannot be empty."
        elif [ -d "$db_name" ]; then
            echo "Database already exists!"
        elif [[ $db_name = *" "* ]]; then
            echo "Database name cannot contain spaces."
            db_name=$(echo ${db_name// /_})
            echo "Spaces may be substituted by underscore as: $db_name"
        elif [[ ! $db_name =~ ^[a-zA-Z_]*$ ]]; then
            echo "Database name cannot contain numbers or special characters!"
        else
            break
        fi
    done

    mkdir "$db_name"
    echo "Database created successfully."
}
