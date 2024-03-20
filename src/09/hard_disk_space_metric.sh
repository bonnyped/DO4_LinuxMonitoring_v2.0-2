#!/bin/bash

disk_part=()
disk_filesystem_type=()
free_space=""
used_space=""
total_size_disk=""
count_dev=0
info_disk=""

filesystem_information() {
    IFS=" " read -r -a disk_part <<< "$(lsblk -io KNAME,TYPE | grep -ie part | awk '{printf "/dev/%s ",$1}')"
    IFS=" " read -r -a disk_filesystem_type <<< "$(lsblk -io KNAME,TYPE,FSTYPE | grep -ie part | awk '{printf "%s ",$3}')"
    for part in "${disk_part[@]}" ; do
        info_disk="$(awk 'NR==2{printf"%s %s %s %s %s %s", $1, $2, $3, $4, $5, $6}' <<<"$(df -B1 "${part}")")"
        info_disk+=" ${disk_filesystem_type[count_dev]}"
        free_space+="$(awk '{printf "filesystem_info_avail_bytes{device=\"%s\", fstype=\"%s\", mountpoint=\"%s\"} %s\\n", $1, $7, $6, $4}' <<<"$info_disk")"
        used_space+="$(awk '{printf "filesystem_info_used_bytes{device=\"%s\", fstype=\"%s\", mountpoint=\"%s\"} %s\\n", $1, $7, $6, $3}' <<<"$info_disk")"
        total_size_disk+="$(awk '{printf "filesystem_total_bytes{device=\"%s\", fstype=\"%s\", mountpoint=\"%s\"} %s\\n", $1, $7, $6, $2}' <<<"$info_disk")"
        count_dev=$((count_dev+1))
    done
}

print_fs_information() {
    echo -en "# HELP filesystem_info_avail_bytes Filesystem space available to non-root users in bytes.\n"
    echo -en "# TYPE filesystem_info_avail_bytes gauge\n"
    echo -e "${free_space}"
    echo -en "# HELP filesystem_total_bytes Filesystem total file nodes.\n"
    echo -en "# TYPE filesystem_total_bytes gauge\n"
    echo -e "${total_size_disk}"
    echo -en "# HELP filesystem_info_used_bytes Filesystem space used to non-root users in bytes.\n"
    echo -en "# TYPE filesystem_info_used_bytes gauge\n"
    echo -e "${used_space}"
}

filesystem_information
print_fs_information