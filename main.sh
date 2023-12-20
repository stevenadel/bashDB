#!/bin/bash
shopt -s extglob
source menus.sh
source ./utils_database/create_database.sh
source ./utils_database/list_database.sh
source ./utils_database/connect_database.sh
source ./utils_database/drop_database.sh
source ./utils_table/create_table.sh
source ./utils_table/list_table.sh
source ./utils_table/select_table.sh
source ./utils_table/insert_table.sh
source ./utils_table/delete_table.sh
source ./utils_table/update_table.sh
source ./utils_table/drop_table.sh
source ./utils_table/data_type_validate.sh

if [[ ! -d ./bashDB ]]
then
    mkdir bashDB
fi
cd bashDB

echo "###################################"
echo "-------- Welcome to bashDB --------"
echo "###################################"
 
main_menu
