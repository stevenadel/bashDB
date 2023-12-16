#!/bin/bash
drop_database() {
    read -p "Choose database to drop: " db_name
    if [[ ! -d "$db_name" ]]
    then
        echo "Database does not exist."
    else
        rm -r "$db_name"
        echo "Dropped database $db_name successfully."
    fi
}
