#!/bin/bash
delete_table() {
    read -e -p "please enter table name to delete from: " table
    while [[ ! -f "$table" && "$table" ]]; do
        echo "Table doesn't exist"
        read -e -p "please enter table name: " table
    done

    select choice in "Delete all records" "Delete record within specific column" "Exit"; do
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
                # Prompt user to enter column name
                read -p "Enter column name: " column
                # Find line number of the column in the metadata file
                col_num=$(grep -n -w "$column" "$table.metadata" | cut -d: -f1)
                # Check if the column name is empty
                if [ -z "$column" ]; then
                    echo "Column name cannot be empty!"
                else
                    if ! grep -q -w "$column" "$table.metadata"; then
                        # Check if the specified column name does not exist in the metadata file
                        echo "Column '$column' does not exist in the table. Please enter a valid column name."
                    else
                        while true; do
                            # Prompt user to enter column value
                            read -p "Enter column value: " value

                            # Check if the column value is empty
                            if [ -z "$value" ]; then
                                echo "Column value can't be empty!"
                            else
                                # Number of records before deleting
                                records_num_old=$(wc -l "$table" | cut -d" " -f1)
                                # Rewrite the table without the matching records
                                awk -v col="$col_num" -v val="$value" -F ":" '$col != val { print $0 }' "$table" > tmp1
                                truncate -s 0 "$table"
                                cat tmp1 >"$table"
                                rm tmp1
                                # Number of records after deleting
                                records_num_new=$(wc -l "$table" | cut -d" " -f1)
                                deleted_records=$(($records_num_old - $records_num_new))
                                echo "$deleted_records records deleted."
                                break
                            fi
                        done
                    break
                    fi
                fi
            done
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