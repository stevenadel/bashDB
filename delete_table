#!/bin/bash
echo -e "\n DELETE \n"
read -e -p "please enter table name: " table_name
table_name=$(echo ${table_name// /_})
while [[ ! -f "$table_name" && "$table_name" ]];
do
	echo "Table doesn't exist"
	read -e -p "please enter table name: " table_name
        table_name=$(echo ${table_name// /_})
done
PS3="Delete FROM $table_name>>"
select choice in "Delete all records without condition" "Delete record with specific column"
do
case $REPLY in 
1) awk 'NR==1 {print > "temp"}' "$table_name"
# empty the original file
truncate -s 0 "$table_name"
# Move the first line from temp to the original file
cat temp > "$table_name"
rm temp
echo "Deleted successfully"
;;
2) while true; do
    read -p "enter condition : Column name >>  " column
    read -p "enter condition : Value  >>  " value
# Check if either the column name or value is empty using '-z' (empty string) test
    if [ -z "$column" ] || [ -z "$value" ]; then
        echo "fields can't be empty!"
    else
# break out of the loop if both column name and value are provided and not empty
        break
    fi
done
column_number=$(grep -n -w $column $table_name.metadata | cut -d: -f1)
awk -v col="$column_number" -v val="$value" -F ":" '$col != val { print $0 }' "$table_name" > tmp1
if [ $(cat tmp1 | wc -l) -eq 1 ]
            then 
                echo "there is no recorders founded"
            else
           truncate -s 0 "$table_name"
           cat tmp1 > "$table_name"
           rm tmp1
           echo "Deleted successfully"
          fi 

;;  
*) echo "please enter value 1 or 2"
;;
esac 
done
