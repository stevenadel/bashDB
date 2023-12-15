#!/bin/bash

# still under work
function create_database() {
    if [[ ! -d ./bashDB ]]
    then
        mkdir bashDB
    fi
    
    cd ./bashDB
    read -p "Please enter database name: " db_name
    # TODO validate_name

    if [[ -d "$db_name" ]]
    then
        echo "Database already exists!"
    else
        mkdir "$db_name"
    fi
}

create_database
