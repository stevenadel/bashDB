#!/bin/bash
update_table() {
    read -p "Please enter table name to update: " table
    while [[ ! -f "$table" ]]; do
        echo -e "Table not found!"
        read -p "Please enter table name to update: " table
    done

    read -p "Enter column name (SET): " col_name
    col_exists=$(cut -d: -f1 $table.metadata | grep -w "$col_name" 2> /dev/null)
    while [[ ! $col_exists ]]; do
        echo -e "Inputted column $col_name does not exist in $table!"
        read -p "Enter column name (SET): " col_name
        col_exists=$(cut -d: -f1 $table.metadata | grep -w "$col_name" 2> /dev/null)
    done

    col_num=$(grep -n -w "$col_name" $table.metadata | cut -d: -f1)
    read -p "Enter column value (SET): " value

    # Returns name:type so must be split to two variables
    col_datatype=$(grep -w "$col_name" $table.metadata)
    IFS=":" read -r col_name datatype <<< "$col_datatype"

    data_type_validate "$value" "$datatype"
    check=$?
    while [[ $check == 1 ]]; do
        echo -e "Input must be of type $datatype."
        read -p "Enter column value (SET): " value
        data_type_validate "$value" "$datatype"
        check=$?
    done

    read -p "Enter column name (WHERE): " colcond
    colcond_exists=$(cut -d: -f1 $table.metadata | grep -w "$colcond" 2> /dev/null)

    while [[ ! "$colcond_exists" ]]; do
        echo "Inputted column $colcond does not exist in $table!"
        read -p "Enter column name (WHERE): " colcond
        colcond_exists=$(cut -d: -f1 $table.metadata | grep -w "$colcond" 2> /dev/null)
    done

    colcond_num=$(grep -n -w "$colcond" $table.metadata | cut -d: -f1)

    read -p "Enter column value (WHERE): " valcond
    while [[ ! $valcond ]]; do
        echo -e "Inputted value cannot be empty!"
        read -p "Enter column value (WHERE): " valcond
    done

    rows_num=$(awk -v COLCOND="$colcond_num" -v VALCOND="$valcond" -v COL="$col_num" -v VAL="$value" 'BEGIN{OFS=FS=":"}{ if($COLCOND==VALCOND) {print $0} }' "$table" | wc -l)
    if [[ "$col_num" == 1 ]]; then
        if [[ "$rows_num" > 1 ]]; then
            echo "Primary key cannot be the same for multiple rows."
            table_menu # Return to secondary menu again
        fi

        # Check if value to set in first column (id) already exists
        value_exists=$(cut -d: -f1 $table | grep -w $value | wc -l)
        if [[ "$value_exists" > 0 ]]; then
            echo "Primary key must be unique."
            table_menu
        fi
    fi

    if [[ "$rows_num" == 0 ]]; then
        echo "No records found!"
    else
        awk -v COLCOND="$colcond_num" -v VALCOND="$valcond" -v COL="$col_num" -v VAL="$value" 'BEGIN{OFS=FS=":"} { if($COLCOND==VALCOND){$COL=VAL}; print $0}' "$table" > tmp
        mv tmp "$table"
        echo "$rows_num rows updated successfully."
    fi
}
