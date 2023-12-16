#!/bin/bash

source menus.sh
source ./utils_database/create_database.sh
source ./utils_database/list_database.sh
source ./utils_database/connect_database.sh
source ./utils_database/drop_database.sh

if [[ ! -d ./bashDB ]]
then
    mkdir bashDB
fi
cd bashDB

echo "###############################"
echo "------ Welcome to bashDB ------"
echo "###############################"
 
main_menu
