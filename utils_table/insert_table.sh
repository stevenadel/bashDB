#!/bin/bash
insert_table() {
    read -e -p "Please enter table name to insert into: " table
    table=$(echo ${table// /_})
    while [[ ! -f "$table" && "$table" ]]; do
        echo "Table not found!"
        read -e -p "Please enter table name to insert into: " table
        table=$(echo ${table// /_})
    done
    user_choice="y"
    while [ $user_choice = y ]; do
        record="-1"
        #loop to show fields to  user
        for field in $(cut -d: -f1,2 ./$table.metadata); do

            IFS=":" read -r field_name field_type <<< "$field"

            read -p "Please enter $field_name: " new_field
            while [ ! "$new_field" ]; do
                echo "No field was entered."
                read -p "Please enter $field_name: " new_field
            done
            
            data_type_validate "$new_field" "$field_type"
            check=$?

            # echo -e "\new_field value is $new_field\n"
            # echo -e "\ncheck value is $check\n"
            while [ "$check" -eq 1 ]; do
                echo "Input must be of type $field_type."
                read -p "Please enter value $field_type for $field_name: " new_field
                data_type_validate "$new_field" "$field_type"
                check=$?
            done
            if [ $record = -1 ]; then
                if grep -wq "^$new_field" ./$table; then
                    echo "Error: The value '$new_field' already exists in the database."
                    break
                fi
                if [[ "${new_field}" =~ ^[0-] ]]; then
                    echo -e "\nError: Primary key can't begin with zero or be negative.\n"
                    break
                fi
                record=$new_field
            else
                record=$record:$new_field
            fi
        done

        if [ "$record" != "-1" ]; then
            echo "$record" >> "$table"
        fi

        read -p "Do you want to insert another record? [y/n]: " user_choice
    done
}