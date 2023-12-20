#!/bin/bash
select_table() {
    read -e -p "Please enter table name to select from: " table_name
    table_name=$(echo ${table_name// /_})
    while [[ ! -f "$table_name" && "$table_name" ]]; do
        echo "Table not found!"
        read -e -p "Please enter table name to select from: " table_name
        table_name=$(echo ${table_name// /_})
    done

    cols_num=$(wc -l < "$table_name.metadata")
    cols=$(awk -F: '{print $1}' "$table_name.metadata")

    unset col_i
    select choice in "Select all" "Select all from specific column" "Select by row (condition)" "Exit"; do
        case $REPLY in
        1)
            column -t -s: "$table_name"
            break
            ;;
        2)
            echo "Choose which column to select from: "
            select choice in $cols; do
                if ((REPLY > cols_num)); then
                    echo "Choose from options 1 to $cols_num."
                else
                    read -p "Do you want to select another column? [y/n]: " another

                    # Represents number of columns desired to be printed
                    if [[ -z $col_i ]]; then
                        col_i="$REPLY"
                    else
                        col_i+=",$REPLY"
                    fi
                fi

                while [[ "$another" != "y" ]] && [[ "$another" != "n" ]]; do
                    read -p "Do you want to select another column? [y/n]: " another
                done

                if [[ $another == "n" ]]; then
                    cut -d: -f"$col_i" "$table_name" | column -t -s:
                    break
                fi
            done
            ;;
        3)  
            # Increment to number cases in select properly
            cols_num=$(($cols_num + 1))
            echo "This feature represents the following SQL query: "
            echo "SELECT field FROM $table_name WHERE primary_key = value;"
            echo -e "\nChoose field to select row by: "
            options=("all" $cols)
            select choice in "${options[@]}"; do
                case $REPLY in
                1)
                    read -p "Enter value of primary key: " primary_key
                    # Print column headers
                    awk -F: 'NR==1 { print $0 }' "$table_name" | column -t -s:
                    # Print selected record
                    grep -w "^$primary_key" "$table_name" | column -t -s:
                    table_menu
                    ;;
                [2-$cols_num])
                    # Decrement back to actual number for acurate cutting
                    REPLY=$(($REPLY - 1))

                    if [[ -z $col_i ]]; then
                        col_i="$REPLY"
                    else
                        col_i+=",$REPLY"
                    fi

                    read -p "Do you want to select another column? [y/n]: " another
                    while [[ "$another" != "y" ]] && [[ "$another" != "n" ]]; do
                        read -p "Do you want to select another column? [y/n]: " another
                    done

                    if [[ "$another" == "y" ]]; then
                        echo "Press Enter to list available options."
                    fi

                    if [[ "$another" == "n" ]]; then
                        read -p "Enter value of primary key: " primary_key
                        # Print column headers (for chosen columns only)
                        head -1 "$table_name" | cut -d: -f"$col_i" | column -t -s:
                        # Print selected record (for chosen columns only)
                        grep -w "^$primary_key" "$table_name" | cut -d: -f"$col_i" | column -t -s:
                        table_menu
                    fi
                    ;;
                *)
                    echo "Choose from options 1 to $cols_num."
                    ;;
                esac
            done
            ;;
        4)  
            break
            ;;
        *)
            echo "Choose from options 1 to 4."
            ;;
        esac
    done
}
