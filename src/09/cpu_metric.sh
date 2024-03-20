#!/bin/bash

cpu_data=""
user=0
system=0
idle=0
one_minute=0
five_minutes=0
fifteen_minutes=0

print_cpu_information() {
    echo -e "# HELP cpu_info_seconds_total Seconds."
    echo -e "# TYPE cpu_info_seconds_total counter"
    echo -e "cpu_info_seconds_total{cpu=\"all\",mode=\"idle\"} $idle"
    echo -e "cpu_info_seconds_total{cpu=\"all\",mode=\"system\"} $system"
    echo -e "cpu_info_seconds_total{cpu=\"all\",mode=\"user\"} $user"
    echo -e "# HELP cpu_info_load1 1m load average."
    echo -e "# TYPE cpu_info_load1 gauge"
    echo -e "cpu_info_load1  $one_minute"
    echo -e "# HELP cpu_info_load15 15m load average."
    echo -e "# TYPE cpu_info_load15 gauge"
    echo -e "cpu_info_load15 $fifteen_minutes"
    echo -e "# HELP cpu_info_load5 5m load average."
    echo -e "# TYPE cpu_info_load5 gauge"
    echo -e "cpu_info_load5 $five_minutes"
    echo -e "# HELP cpu_uptime_info"
    echo -e "# TYPE cpu_uptime_info counter"
    echo -e "cpu_uptime_info $cpu_uptime"
    echo -e "# HELP cpu_downtime_info"
    echo -e "# TYPE cpu_downtime_info counter"
    echo -e "cpu_downtime_info $cpu_downtime"
    echo -e "# HELP cpu_number_processor_cores_info"
    echo -e "# TYPE cpu_number_processor_cores_info gauge"
    echo -e "cpu_number_processor_cores_info $number_of_processor_cores"
} 

cpu_metric_information() {
    cpu_data="$(awk 'NR==1{print $2" "$4" "$5}' "/proc/stat" )"
    uptime_data=$(awk 'NR==1{print $1" "$2}' "/proc/uptime" )
    user="$(awk '{print $1*0.01}'<<<"$cpu_data")"
    system="$(awk '{print $2*0.01}'<<<"$cpu_data")"
    idle="$(awk '{print $3*0.01}'<<<"$cpu_data")"
    one_minute=$(awk '{print $1}' "/proc/loadavg")
    five_minutes=$(awk '{print $2}' "/proc/loadavg")
    fifteen_minutes=$(awk '{print $3}' "/proc/loadavg")
    number_of_processor_cores="$(nproc)"
    cpu_uptime=$(awk '{print $1}' <<<"${uptime_data}")
    cpu_downtime=$(awk '{print $2}' <<<"${uptime_data}")
}

cpu_metric_information
print_cpu_information 
