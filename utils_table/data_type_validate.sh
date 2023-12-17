#!/bin/bash

# Takes two parameters, checks that the first parameter is of valid type second parameter to use in database
data_type_validate() {
    valid=-1
    case $2 in
        *int )
            if [[ "$1" =~ ^[0-9_]+$ ]]; then
                valid=1
            fi
            ;;
        *string )
            if [[ $1 =~ ^[a-zA-Z0-9]+$ ]]; then
                valid=1
            fi
            ;;
        *float )
            if [[ $1 =~ ^[+-]?[0-9]+\.?[0-9]*$ ]]; then
                valid=1
            fi
            ;;
        * )
            valid=0
            ;;
    esac
    return $valid
}
