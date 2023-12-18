#!/bin/bash
function delete_table {
    read -e -p "please enter table name to delete from: " table
    table=$(echo ${table// /_})

    while [[ ! -f "$table" && "$table" ]]
    do
        echo "Table doesn't exist"
        read -e -p "please enter table name: " table
        table=$(echo ${table// /_})
    done

    select choice in "Delete all records" "Delete record within specific column" "Exit"
    do
        case $REPLY in
        1)
            awk 'NR==1 {print > "temp"}' "$table"
            # empty the original file
            truncate -s 0 "$table"
            # Move the first line from temp to the original file
            cat temp >"$table"
            rm temp
            echo "Deleted successfully"
            ;;
        2)
            while true; do
                read -p "Enter column name: " column
                read -p "Enter column value: " value
                # Check if either the column name or value is empty using '-z' (empty string) test
                if [ -z "$column" ] || [ -z "$value" ]
                then
                    echo "fields can't be empty!"
                else
                    # break out of the loop if both column name and value are provided and not empty
                    break
                fi
            done
            col_num=$(grep -n -w $column $table.metadata | cut -d: -f1)
            awk -v col="$col_num" -v val="$value" -F ":" '$col != val { print $0 }' "$table" > tmp1
            if [ $(cat tmp1 | wc -l) -eq 0 ]
            then
                echo "No records found"
            else
                truncate -s 0 "$table"
                cat tmp1 > "$table"
                rm tmp1
                echo "Deleted successfully."
            fi

            ;;
        3)
            break
            ;;
        *)
            echo "please from options 1-3"
            ;;
        esac
    done
}
