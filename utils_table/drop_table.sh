#!/bin/bash
while true; do
    read -e -p "please enter table name to drop: " table
    table=$(echo ${table// /_})

    if [ -z "$table" ]; then
        echo -e "You didn't enter a table name."
        continue
    fi

    if [ ! -f "$table" ]; then
        echo -e "Table not found!"
        continue
    fi

    break
done

rm "$table"
rm "$table.metadata"
echo -e "table $table dropped successfully"
