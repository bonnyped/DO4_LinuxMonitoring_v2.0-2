#!/bin/bash

allow_execution() {
    chmod +x cpu_metric.sh create_file.sh hard_disk_space_metric.sh main.sh ram_metric.sh
}

path_determinant() {
    folder_run="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/"
}

install_nginx() {
    status_install="$(dpkg -l | grep nginx)"
    if [[ -z "$status_install" ]] ; then 
        sudo apt install -y nginx
    fi
}

prepararing_for_monitoring() {
    sudo systemctl restart  prometheus grafana-server.service 
    bash "${folder_run}create_file.sh"
    sudo cp "${folder_run}nginx.conf" /etc/nginx/nginx.conf 
    sudo nginx -t
    sudo service nginx restart
    sudo cp "${folder_run}prometheus.yml" /etc/prometheus/prometheus.yml
    sudo systemctl restart prometheus.service
}

run_monitoring() {
    while true ; do
        if [[ -f "${folder_run}metrics.html" ]] ; then
                rm -f "${folder_run}metrics.html"
        fi
        bash "${folder_run}ram_metric.sh" > "${folder_run}metrics.html"
        bash "${folder_run}cpu_metric.sh" >> "${folder_run}metrics.html"
        bash "${folder_run}hard_disk_space_metric.sh" >> "${folder_run}metrics.html"
		sleep 3;
	done
}

if [[ $# -eq 0 ]] ; then
allow_execution
    path_determinant
    install_nginx
    prepararing_for_monitoring
    run_monitoring
else
    echo -e "The script runs without parameters..."
fi
