#!/bin/bash
function create_table() {
    while true; do
        read -p "Please enter table name: " name
        if [[ $name = " " ]]; then
            echo "Name of table can't contain spaces."
            name=$(echo ${name// /_})
            echo "New name: $name"
        elif [ -z "$name" ]; then
            echo "Please enter a table name."
        elif [[ ! $name =~ ^[a-zA-Z]*$ ]]; then
            echo "Name of table can't contain special characters or numbers!"
        elif [ -f "$name" ]; then
            echo "Table already exists!"
        else
            break
        fi
    done

    touch $name
    touch $name.metadata
    read -p "Please enter number of columns " cols
    # Loop until a valid number of columns is entered
    while [ -z "$cols" ]; do
        read -p "Please enter number of columns: " cols
    done

    # Loop until a valid primary key is entered
    while [ -z "$primary_key" ]; do
        read -p "Please enter primary key of table: " primary_key
    done
    header=$primary_key
    
    while true; do
        read -p "Please enter type of primary key (int - string - float): " primary_key_type

        if [[ $primary_key_type == "int" ]] || [[ $primary_key_type == "string" ]] || [[ $primary_key_type == "float" ]]; then
            break
        fi

        echo -e "Incorrect input! Please enter (int - string - float)"
    done
    pk=$primary_key:$primary_key_type
    echo $pk >>$name.metadata
    cols=$((cols - 1))
    iter_num=0
    field_number=2

    while [ $iter_num -lt $cols ]; do
        read -p "please enter field ${field_number} name:" field

        while true; do
            column_exists=$(cut -d: -f1 "$name.metadata" | grep -w "$field" 2>/dev/null)

            if [ "$column_exists" ]; then
                echo "Column already exists in table $name!"
            elif [ ! "$field" ]; then
                echo "Please enter a valid field name"
            else
                break
            fi

            read -p "please enter field ${field_number} name :" field
        done

        while true; do
            read -p "please enter field ${field_number} type (int - string - float) " field_type

            if [[ $field_type != "int" ]] && [[ $field_type != "string" ]] && [[ $field_type != "float" ]] || [[ ! $field_type ]]; then
                echo -e "Wrong input! please enter (int - string - float)"
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
