#!/bin/bash
dir='_posts'

mkdir -p ${dir}
baseurl=$(cat _config.yml | yq r - -d '*' 'baseurl' | tr -d '/')
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
        echo 'title: "'${raw_file_name}'"' >> ${dir}/${filename}

        timestamp=$(echo ${json} | jq -r '.timestamp')
        if [[ ${timestamp} ]]; then
            echo 'last_modified_at: "'${timestamp}'"' >> ${dir}/${filename} #TODO date formatting
        fi

        echo "source: "/${baseurl}/casts/${cast_file} >> ${dir}/${filename}

        echo "---" >> ${dir}/${filename}

    else
        echo "file found ${dir}/$filename skipping..."
    fi

done
