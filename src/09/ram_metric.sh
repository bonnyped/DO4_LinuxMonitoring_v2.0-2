#!/bin/bash

meminfo_data=0
memory_total=0
memory_free=0
memory_available=0
memory_buffers=0
memory_cashed=0

memory_ram_info() {
   meminfo_data="$(awk 'NR>=1 && NR<=10{print $0}' "/proc/meminfo" )"
   memory_total="$(awk 'NR==1{print $2}'<<<"$meminfo_data")"
   memory_free="$(awk 'NR==2{print $2}'<<<"$meminfo_data")"
   memory_available="$(awk 'NR==3{print $2}'<<<"$meminfo_data")"
   memory_buffers="$(awk 'NR==4{print $2}'<<<"$meminfo_data")"
   memory_cashed="$(awk 'NR==5{print $2}'<<<"$meminfo_data")"

}

print_metrics_format_prometheus() {
   # все
   echo -e "# HELP memory_ram_info_total_bytes Memory information field MemBuffCashe_bytes."
   echo -e "# TYPE memory_ram_info_total_bytes gauge"
   echo -e "memory_ram_info_total_bytes $memory_total"

   # свободная
   echo -e "# HELP memory_ram_info_free_bytes Memory information field MemFree_bytes."
   echo -e "# TYPE memory_ram_info_free_bytes gauge"
   echo -e "memory_ram_info_free_bytes $memory_free"
   # доступная
   echo -e "# HELP memory_ram_info_available_bytes Memory information field MemUsed_bytes."
   echo -e "# TYPE memory_ram_info_available_bytes gauge"
   echo -e "memory_ram_info_available_bytes $memory_available"
   # буфферы
   echo -e "# HELP memory_ram_info_buffers_bytes Memory information field MemShared_bytes."
   echo -e "# TYPE memory_ram_info_buffers_bytes gauge"
   echo -e  "memory_ram_info_buffers_bytes  $memory_buffers"
   # кэш
   echo -e  "# HELP memory_ram_info_cashed_bytes Memory information field MemBuffCashe_bytes."
   echo -e  "# TYPE memory_ram_info_cashed_bytes gauge"
   echo -e "memory_ram_info_cashed_bytes $memory_cashed"
}

memory_ram_info
print_metrics_format_prometheus