#!/bin/bash

for file in $(ls output); do 
    mv "output/$file" `echo $file | tr '' '_'`
done

find -name "* *" -type d | rename 's/ /_/g'