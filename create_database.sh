#!/bin/bash
function create_database {
    while true; do
        read -p "Please enter database name: " db_name

        # Check for spaces in the name
        if [[ $db_name = *" "* ]]; then
            echo "Name of the database can't contain spaces!"
            db_name=$(echo ${db_name// /_})
             echo "New name: $db_name"
             break
        # Check if the name is empty
        elif [ ! "$db_name" ]; then
            echo "You didn't enter a database name"
        # Check for special characters or numbers in the name
        elif [[ ! "$db_name" =~ ^[a-zA-Z]*$ ]]; then
            echo "Name of the database can't contain special characters or numbers!"
        # Check if the database already exists
        elif [ -e "./bashDB/$db_name" ]; then
            echo "Database already exists!"
        else
            break
        fi

        read -p "Please enter database name: " db_name
    done

    mkdir -p "./bashDB/$db_name"
    echo "Database created successfully"
}
