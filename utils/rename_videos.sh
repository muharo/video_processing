#!/bin/bash

# Check path argument is valid
if [[ -z "$1" || $1 != /* ]]; then
        echo "Invalid path! It should be an absolute path!"
        exit 1
elif [[ ! -d $1 ]]; then
        echo "Invalid path! Directory doesn't exist!"
        exit 1
else
        path=$1
fi

# Initialize counter
i=1

# Do the renaming
for file in $path/*; do
        ext=$(echo $file | rev | cut -d'.' -f 1 | rev)
        mv "$file" "${path}/video${i}.${ext}"
        let "i=i+1"
done

# Print final list
ls -1v $path