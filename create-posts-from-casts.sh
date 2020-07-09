#!/bin/bash
dir='_posts'

formatDate() {
    unix_timestamp=$1
    os=$(uname)
    if [[ ${os} == "Darwin" ]]; then
        formatteddate=$(date -ur ${unix_timestamp} +%Y-%m-%d)
    elif [[ ${os} == "Linux" ]]; then
        formatteddate=$(date -d @${unix_timestamp} +%Y-%m-%d)
    fi
    echo "Formatted Date: $formatteddate"
    export RET=${formatteddate}
}


mkdir -p ${dir}
baseurl=$(cat _config.yml | grep baseurl | head -n 1 | awk -F ':' '{print $2}'| tr -d '/' | tr -d ' ')
for file in casts/*; do
    json=$(head -n 1 $file)
    timestamp=$(echo ${json} | jq -r '.timestamp')
    formattedDate=""
    if [[ ${timestamp} ]]; then
        formatDate ${timestamp}
        formattedDate="${RET}"
        unset RET
    fi
    filename=$(basename $file  | awk -F '.' '{print $1}')
    cast_file=$(basename $file)
    raw_file_name=${filename}
#    curr_date=$(date +%Y-%m-%d)
    filename=${formattedDate}-${filename}.md
    if [[ ! -f ${dir}/${filename} ]]; then
        echo "No file found... making one ${dir}/${filename}"
        echo "---" > ${dir}/${filename}
        echo 'title: "'${raw_file_name}'"' >> ${dir}/${filename}

        if [[ $formattedDate ]]; then
            echo 'last_modified_at: "'${unix_timestamp}'"' >> ${dir}/${filename} #TODO date formatting
        fi

        echo "source: "/${baseurl}/casts/${cast_file} >> ${dir}/${filename}

        echo "---" >> ${dir}/${filename}

    else
        echo "file found ${dir}/$filename skipping..."
    fi

done
