#!/bin/bash
list_table() {
    echo "Exisitng tables:"
    tables=`ls . | grep -v ".metadata"`
    echo "$tables"
}
