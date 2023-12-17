#!/bin/bash
select_table() {
    read -e -p "please enter table name to select from: " table_name
    table_name=$(echo ${table_name// /_})
    while [[ ! -f "$table_name" && "$table_name" ]];
    do
        echo "Table doesn't exist"
        read -e -p "please enter table name: " table_name
            table_name=$(echo ${table_name// /_})
    done

    num_of_cols=$(wc -l <"$table_name.metadata")
    cols=$(awk -F: '{print $1}' "$table_name.metadata")

    select choice in "Select all" "Select all in specific columns" "Select with condition" "exit"
    do
        case $REPLY in
        1)
            column -t -s: $table_name
            break
            ;;
        2)
            echo "Choose the columns you want to select"
            select choice in $cols; do
                if ((REPLY > num_of_cols)); then
                    echo "Select number from 1 to $num_of_cols"
                else
                    another="y"
                    x="$REPLY"
                    for val in "${arr[@]}"; do
                        x+=",$val"
                    done
                fi
            done

            if [ "$another" != n ] && [ "$another" != y ]; then
                read -p "Select another column? y/n: " another
            fi

            if [ $another == n ]; then
                cut -d: -f$x $table_name | column -t -s:

                # Display content and prompt for return to menu or exit
                read -p "Return to menu? y/n" back_menu

                if [ $back_menu == y ]; then
                    break
                else
                    select_table.sh $1
                fi
            fi
            ;;
        3)  # Incrementing number of columns
            num_of_cols=$(($num_of_cols + 1))

            echo "SELECT -FIELDS- FROM $table_name WHERE -PRIMARYKEY- = -value-"
            echo "Enter the fields you want to select :"

            echo "Enter your choice:"
            options=("all" "${cols[@]}")
            select choice in "${options[@]}"; do
                case $REPLY in
                1)
                    read -p "Enter value of pk: " pk
                    awk -F: 'NR==1 { print $0 }' "$table_name" | column -t -s:
                    grep -w "^$pk" "$table_name" | column -t -s:
                    break
                    ;;
                [2-$num_of_cols])
                    read -p "Choose another column? y/n: " comp
                    x=$REPLY
                    arr[$REPLY]=$REPLY

                    while [ "$comp" != "n" ]; do
                        read -p "Choose another column? y/n: " comp
                        if [ "$comp" == "n" ]; then
                            read -p "Enter value of pk: " pk
                            awk -v x="$x" -F: 'NR==1 {print $x}' "$table_name" | column -t -s:
                            grep -w "^$pk" "$table_name" | awk -v x="$x" -F: '{print $x}' | column -t -s:
                            break
                        fi
                        read -p "Choose another column? y/n: " comp
                        x+=",${REPLY}"
                    done
                    break
                    ;;
                *)
                    echo "Please enter a number from 1 to $num_of_cols"
                    ;;
                esac
            done
            ;;
        4)  
            break
            ;;
        *)
            echo "enter value from 1 to 4"
            ;;
        esac
    done
}
