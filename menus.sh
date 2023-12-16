#!/bin/bash

main_menu() {
    PS3="bashDB>> "
    echo -e "\nSelect database operation:"
    select choice in 'Create Database' 'List Databases' 'Connect to Database' 'Drop Database' 'Exit'
    do
        case $REPLY in
        1) create_database
        ;;
        2) list_database
        ;;
        3) connect_database
        ;;
        4) drop_database
        ;;
        5) exit 0
        ;;
        *) echo "Please choose from available options 1-5."
           main_menu
        ;; 
        esac
    done
}

table_menu() {
    echo -e "\nSelect table operation:"
    select choice in 'Create Table' 'List Table' 'Select from Table' 'Insert into Table' 'Delete from Table' 'Update Table' 'Drop Table' "Exit Table $1"
    do
        case $REPLY in
        1) create_table
        ;;
        2) list_table
        ;;
        3) select_table
        ;;
        4) insert_table
        ;;
        5) delete_table
        ;;
        6) update_table
        ;;
        7) drop_table
        ;;
        8)  cd ..
            main_menu
        ;;
        *) echo "Please choose from available options 1-8."
           table_menu
        ;; 
        esac
    done
}

