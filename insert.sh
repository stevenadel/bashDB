#!/bin/bash
echo -e "\nINSERT\n "

function data_type_validate {
vali=-1

case $2 in
    *int )
        if [[ $1 =~ ^[+-]?[0-9]+$ ]]; then
            vali=1
        fi
        ;;
    *string )
        if [[ $1 =~ ^[a-zA-Z0-9]+$ ]]; then
            vali=1
        fi
        ;;
    *float )
        if [[ $1 =~ ^[+-]?[0-9]+\.?[0-9]*$ ]]; then
            vali=1
        fi
        ;;
    * )
        vali=0
        ;;
esac

return $vali
}
read -e -p "please enter table name: " table
table=$(echo ${table// /_})
while [[ ! -f "$table" && "$table" ]];
do
	echo "Table doesn't exist"
	read -e -p "please enter table name: " table
        table=$(echo ${table// /_})
done
user_choice="y"
while [ $user_choice = y ]
do
#loop to show fields to  user
	record="-1"
        cut -d: -f1,2 ./$table.metadata | while read -r field; do
          read -p "please enter $field " new_field
          while [ ! "$new_field" ]; do
          echo "no field was entered "
        read -p "please enter $field " new_field
    done
done
data_type_validate $new_field $field
check=$?

while true; do
    if [ "$check" -eq 0 ]; then
        echo "data types don't match"
        read -p "please enter $field: " new_field
        data_type_validate "$new_field" "$field"
        check=$?
    else
        break
    fi
done
if grep -wq "^$new_field" ./$table; then
    echo "Error: The value '$new_field' already exists in the database."
    break
fi
 if [[ "${new_field}" =~ ^[0-] ]]; then
        echo -e "\nError: Primary key can't begin with zero or be negative.\n"
        break
    fi

    record=$new_field
else
    record=$record:$new_field
fi
done
if [ "$record" != "-1" ]; then
        echo "$record" >> "$table"
    fi

    read -p "Do you want to enter another record? [y/n]: " user_choice
done
