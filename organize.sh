#!/usr/bin/bash -i

organize_files(){
    directory=$1
    if [ ! -e "$directory" ]; then
        echo "Path \"$directory\" doesn't exists"
        return 1
    else
        echo "Path \"$directory\" exists"
    fi 
    
    for file in "$directory"/*; do
        if [ -f "$file" ]; then
            extension="${file##*.}"
            filename=$(basename "$file")
            echo 
            if [[ "$extension" == "$file" || "$extension" == "unknown" ||  "${filename:0:1}" == "."  ]];  then
                
                if [ ! -d "$directory/misc" ]; then
                    mkdir "$directory/misc" 
                fi
                mv "$file" "$directory/misc/"
            else 
                if [ ! -d "$directory/$extension" ]; then
                    mkdir "$directory/$extension" 
                fi
                mv "$file" "$directory/$extension/"
            fi
        fi
    done  
}
organize_files "$1"
