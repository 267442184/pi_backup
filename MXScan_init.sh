#!/bin/bash
function deleteDir(){
    currentTime=`date +%s`

    for element in `ls $1`
    do  
        dir_or_file=$1"/"$element
        if [ -d $dir_or_file ]; then
            fileTime=$((element))
            offset=$((currentTime-fileTime))
            #echo "fileTime: $fileTime"
            #echo "currentTime: $currentTime"
            if [ $offset -gt $period ]; then
                #echo "will delete $element"
                `rm -rf $dir_or_file`
            fi
        fi  
    done
}

period=$((3600*3*1))
root_dir="/mnt/mxlog/log/"
deleteDir $root_dir

#date +%s
