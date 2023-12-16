#!/bin/bash
source data_type_validate
echo -e "\nUPDATE\n"

read -e -p "please enter table name: " table_name
table_name=$(echo ${table_name// /_})
while [[ ! -f "$table_name" && "$table_name" ]];
do
	echo "Table doesn't exist"
	read -e -p "please enter table name: " table_name
        table_name=$(echo ${table_name// /_})
done
PS3="Update from $table_name >> "
read -p "enter : Column name >>  " column 
cut_output=$(cut -d: -f1 "$tableName.metadata")
column_found=$(echo "$cut_output" | grep -w "$column" 2> /dev/null)
while [ ! $column_found ];do
		echo -e "\ncolumn doesn't exist in table $table_name\n"
		read -p "enter : Column name :   " column 
		cut_output=$(cut -d: -f1 "$tableName.metadata")
                column_found=$(echo "$cut_output" | grep -w "$column" 2> /dev/null)
			
	done
column_number=$(grep -n -w $column $table_name.metadata | cut -d: -f1)
read -p "enter  : $column value: " c_value
data_type=$(grep -w "$column" "$table_name.metadata")
data_type_validate $c_value $data_type
check=$?

while true
do
    if [ "$check" -eq 0 ]; then
        echo "data types don't match"
        read -p "enter  : $column value: " c_value
        data_type_validate $c_value $data_type
        check=$?
    else
        break
    fi
done
read -p "enter condition : Column name :  " col_cond
col_cond_found=(echo "$cut_output" | grep -w "$col_cond" 2> /dev/null)
while [ ! $col_cond_found ];do
		echo -e "\ncolumn doesn't exist in table $table_name\n"
		read -p "enter : Column name :   " col_cond
                cut_output=$(cut -d: -f1 "$tableName.metadata")
                col_cond_found=$(echo "$cut_output" | grep -w "$col_cond" 2> /dev/null)
			
	done
col_con_num=$(grep -n -w "$col_cond" "$table_name.metadata" | cut -d: -f1)
read -p "enter condition : Value  :  " val_cond
while [ ! $val_cond ];do
		echo -e "\nCannot set empty value\n"	
		read -p "enter condition : Value  >>  " val_cond	
	done
num_of_rows=$(awk -v colcond="$column_cond_num" -v valcond="$val_cond" -v col="$column_number" -v val="$c_value" -F ":" '($col_cond == valcond) && ($col == val) {count++} END{print count}' "$table_name")
if [ "$column_number" -eq 1 ]; then
    value_found=$(awk -v val="$value" -F: '$1 == val {count++} END {print count}' "$table_name")
    
    if [ "$value_found" -gt 0 ]; then
        echo "Value of primary key already exists"
        exit
    fi
    
    if [ "$num_of_rows" -gt 1 ]; then
        echo "Can't set the same primary key value for multiple rows"
        exit
    fi
fi

if [ "$num_of_rows" -eq 0 ]; then

	echo "no match found"
	#perform update
	else
		awk -v colcond="$column_cond_num" -v valcond="$val_cond" -v col="$column_number" -v val="$c_value" 'BEGIN{OFS=FS=":"}{ if($colcond==valcond){$col=val};print $0}' $table_name > temp
		mv temp $table_name
		echo " $num_of_rows rows affected successfully"
	fi
