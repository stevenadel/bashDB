#!/bin/bash
connect_database() {
    read -p "Choose database to connect to: " db_name
    if [[ ! -d "$db_name" ]]
    then
        echo "Database does not exist."
    else
        cd "$db_name"
        echo "Connected to database $db_name successfully."
        PS3="bashDB $db_name>> "
        table_menu "$db_name"
    fi
}
