#!/bin/bash
dir='_posts'
#for file in $(ls casts/*); do
for file in casts/*; do
    #chmod +r $file
    #echo $file
    json=$(head -n 1 $file)
    filename=$(basename $file)
    #echo $json | jq
    if [[ ! -f ${dir}/${filename}.md ]]; then
        echo "No file found... making one ${dir}/${filename}"
        echo "---" > ${dir}/${filename}.md
        echo 'title: "'${file}'"' >> ${dir}/${filename}.md

        timestamp=$(echo ${json} | jq -r '.timestamp')
        if [[ ${timestamp} ]]; then
            echo 'last_modified_at: "'${timestamp}'"' >> ${dir}/${filename}.md #TODO date formatting
        fi

        echo "source: "${file} >> ${dir}/${filename}.md

        echo "---" >> ${dir}/${filename}.md

    else
        echo "file found ${dir}/$filename}.md skipping..."
    fi

done
