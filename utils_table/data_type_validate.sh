#!/bin/bash

# Takes two parameters, checks that the first parameter is of valid type second parameter to use in database
data_type_validate() {
    # Not valid by default
    valid=1

    case $2 in
        [iI][nN][tT])
            if [[ "$1" =~ ^[0-9]+$ ]]; then
                valid=0  # Exit code zero == true
            fi
            ;;
        [sS][tT][rR][iI][nN][gG])
            # if [[ "$1" =~ ^[a-zA-Z_][a-zA-Z0-9_[:space:]]+$ ]]; then
            # fi
                # all characters are accept in string
                valid=0
            ;;
        *)
            valid=1
            ;;
    esac
    return $valid
}