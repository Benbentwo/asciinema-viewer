#!/bin/bash
dir='_posts'

mkdir -p ${dir}
for file in casts/*; do
    json=$(head -n 1 $file)
    filename=$(basename $file  | awk -F '.' '{print $1}')
    cast_file=$(basename $file)
    raw_file_name=${filename}
    curr_date=$(date +%Y-%m-%d)
    filename=${curr_date}-${filename}.md
    if [[ ! -f ${dir}/${filename} ]]; then
        echo "No file found... making one ${dir}/${filename}"
        echo "---" > ${dir}/${filename}
        echo 'title: "'${file}'"' >> ${dir}/${filename}

        timestamp=$(echo ${json} | jq -r '.timestamp')
        if [[ ${timestamp} ]]; then
            echo 'last_modified_at: "'${timestamp}'"' >> ${dir}/${filename} #TODO date formatting
        fi

        echo "source: "${cast_file} >> ${dir}/${filename}

        echo "---" >> ${dir}/${filename}

    else
        echo "file found ${dir}/$filename skipping..."
    fi

done
