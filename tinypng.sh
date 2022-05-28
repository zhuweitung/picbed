#!/bin/bash

# 获取最新提交的新增图片文件
last_add_img_files=$(git log --pretty=format:"" --name-status -1 | grep '^A(jpg\|png\|gif\|ico)' | awk '{print $2}')
if [[ ${#last_add_img_files[@]} > 0 ]]; then
    mkdir tinypng_tmp
    echo 'create tinypng_tmp'
    add_file_num=0
    for file in $last_add_img_files; do
        if [[ -f $file ]]; then
            add_file_num=$((add_file_num+1))
            cp $file tinypng_tmp && echo -e "move ${file} to tinypng_tmp"
        fi
    done
    [[ $add_file_num > 0 ]] && cd tinypng_tmp && super-tinypng && cp output/* ../ && echo 'compress success' && cd ..
    rm -rf tinypng_tmp
fi

last_update_img_files=$(git log --pretty=format:"" --name-status -1 | grep '^M(jpg\|png\|gif\|ico)' | awk '{print $2}')
if [[ ${#last_update_img_files[@]} > 0 ]]; then
    for file in $last_update_img_files; do
        [[ -f $file ]] && echo -e "will flush jsdelivr cdn of ${file}" && curl -s https://cdn.jsdelivr.net/gh/acerbot/picbed/${file} && echo 'flush success'
    done
fi