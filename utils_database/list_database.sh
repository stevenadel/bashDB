#!/bin/bash
list_database() {
    databases=$(ls -F | grep /)
    if [[ -z "${databases// }" ]]
    then
        echo "No databases found."
    else
        echo "$databases"
    fi
}
