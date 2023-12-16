#!/bin/bash

main_menu() {
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

