#!/bin/bash
echo -e "\nDROP Table\n "
while true; do
    read -e -p "please enter table name: " table
    table=$(echo ${table// /_})

    if [ -z "$table" ]; then
        echo -e "\nYou didn't enter a table name\n"
        continue
    fi

    if [ ! -f "$table" ]; then
        echo -e "\nTable not found\n"
        continue
    fi

    break
done

rm "$table"
rm "$table.metadata"
echo -e "\ntable $table dropped successfully\n"
