#!/bin/bash

python3 boostnote2md.py
cd output
for i in *;do mv "$i" "${i// /-}";done
cp -r * ../
cd ..
rm -r output
