#!/bin/bash
update_table() {
    read -p "Please enter table name to update: " table
    while [ ! -f $table -a $table ]; do
        echo -e "Table doesn't exist"
        read -p "Please enter table name: " table
    done
    echo "Updating from $table >> "

    read -p "Enter column name to SET: " column
    col_exists=$(cut -d: -f1 $table.metadata | grep -w $column 2>/dev/null)
    while [ ! $col_exists ]; do
        echo -e "column doesn't exist in $table"
        read -p "Enter column name SET: " column
        col_exists=$(cut -d: -f1 $table.metadata | grep -w $column 2>/dev/null)
    done

    col_num=$(grep -n -w $column $table.metadata | cut -d: -f1)
    read -p "Enter column value SET: " value
    datatype=$(grep -w $column $table.metadata)
    data_type_validate $value $datatype
    check=$?
    while [ $check = 0 ]; do
        echo -e "Incorrect data type."
        read -p "Enter column value SET: " value
        data_type_validate $value $datatype
        check=$?
    done

    read -p "Enter column name WHERE: " colcond
    colcond_exists=$(cut -d: -f1 $table.metadata | grep -w $colcond 2>/dev/null)

    while [ ! $colcond_exists ]; do
        echo "column doesn't exist in $table"
        read -p "Enter column name WHERE: " colcond
        colcond_exists=$(cut -d: -f1 $table.metadata | grep -w $colcond 2>/dev/null)
    done

    colcond_num=$(grep -n -w $colcond $table.metadata | cut -d: -f1)

    read -p "Enter column value WHERE: " valueCond
    while [ ! $valueCond ]; do
        echo -e "Cannot set empty value"
        read -p "Enter column value WHERE: " valueCond
    done

    rows_num=$(awk -v COLCOND=$colcond_num -v VALCOND=$valueCond -v COL=$col_num -v VAL=$value 'BEGIN{OFS=FS=":"}{ if($COLCOND==VALCOND){print $0}}' $table | wc -l)
    if [ $col_num == 1 ]
    then
        value_exists=$(cut -d: -f1 $table | grep -w $value | wc -l)
        if [ $value_exists -gt 0 ]; then
            echo "Primary key must be unique."
            exit
        fi
        if [ $rows_num -gt 1 ]; then
            echo "Primary key cannot be the same for multiple rows."
            exit
        fi
    fi

    if [[ $rows_num == 0 ]]
    then
        echo "No records found"
    else
        awk -v COLCOND=$colcond_num -v VALCOND=$valueCond -v COL=$col_num -v VAL=$value 'BEGIN{OFS=FS=":"} { if($COLCOND==VALCOND){$COL=VAL}; print $0}' $table > tmp
        mv tmp "$table"
        echo " $rows_num rows updated successfully."
    fi
}
