#!/bin/bash

# still under work
function create_table() {
    read -p "Enter table name to create: " table
    if [[ -f $table ]]
    then
        echo "Table $table already exists!"
        create_table
    else
        # TODO validate_name function
        touch $table
    fi
}
