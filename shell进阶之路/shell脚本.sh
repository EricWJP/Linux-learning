#!/bin/bash
line="(123) 456-7891"
echo "111"
echo "222"
if [[ $line =~ (^[0-9]{3}-[0-9]{3}-[0-9]{4}$) ]] || [[ $line =~ ^\([0-9]{3}\)\ [0-9]{3}-[0-9]{4}$ ]] 
    then
        echo $line
fi
 # \d{3}-\d{3}-\d{4}|\(\d{3}\)\s\d{3}-\d{4}
