#!/bin/bash
create_table() {
    while true; do
        read -p "Please enter table name to create: " name
        if [[ -z "$name" ]]; then
            echo "Table name cannot be empty."
        elif [ -f "$name" ]; then
            echo "Table already exists!"
        elif [[ $name = *" "* ]]; then
            echo "Table name cannot contain spaces."
            name=$(echo ${name// /_})
            echo "Spaces may be substituted by underscore as: $name"
        elif [[ ! $name =~ ^[a-zA-Z_]*$ ]]; then
            echo "Table name cannot contain numbers or special characters!"
        else
            break
        fi
    done

    touch $name
    touch $name.metadata

    # Loop until a valid number of columns is entered
    while true; do
        read -p "Enter a number of columns: " cols

        # Check if the input is non-empty
        if [[ -z $cols ]]; then
            echo "Invalid input. Please enter a non-empty value."
        # Check if the input is a positive integer
        elif [[ ! $cols =~ ^[1-9][0-9]*$ ]]; then
            echo "Invalid input. Please enter the colmuns number as positive integer ONLY."
        else
            break
        fi
    done

    # Loop until a valid primary key is entered
    while [ -z "$primary_key" ]; do
        read -p "Please enter primary key of table: " primary_key
    done
    header=$primary_key

    while true; do
        read -p "Please enter type of primary key (int or string): " primary_key_type

        if [[ $primary_key_type == "int" ]] || [[ $primary_key_type == "string" ]]; then
            break
        fi

        echo -e "Incorrect input! Please enter (int or string)."
    done
    pk=$primary_key:$primary_key_type
    echo $pk >>$name.metadata
    cols=$((cols - 1))
    iter_num=0
    field_number=2

    while [ $iter_num -lt $cols ]; do
        read -p "please enter field ${field_number} name: " field

        while true; do
            column_exists=$(cut -d: -f1 "$name.metadata" | grep -w "$field" 2>/dev/null)

            if [ "$column_exists" ]; then
                echo "Column already exists in table $name!"
            elif [ ! "$field" ]; then
                echo "Please enter a valid field name: "
            else
                break
            fi

            read -p "please enter field ${field_number} name: " field
        done

        while true; do
            read -p "please enter field ${field_number} type (int or string) " field_type

            if [[ $field_type != "int" ]] && [[ $field_type != "string" ]] || [[ ! $field_type ]]; then
                echo -e "Wrong input! please enter (int or string)."
            else
                break
            fi
        done

        header="$header:$field"
        entry="$field:$field_type"
        echo "$entry" >>"$name.metadata"

        ((iter_num++))
        ((field_number++))
    done

    echo "$header" >> "$name"
}
