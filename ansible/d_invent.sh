#!/bin/bash
ext_app=$(gcloud compute instances list | grep app | awk '{print$5}') 
ext_db=$(gcloud compute instances list | grep db | awk '{print$5}')
int_db=$(gcloud compute instances list | grep db | awk '{print$4}')
ans_cfg=$(cat ansible.cfg | grep inve|  awk '{print$3}' | cut -c 3-)
echo "Create inventory config ansible"
printf " 
[app]\n
appserver ansible_host=$ext_app\n
[db]\n
dbserver ansible_host=$ext_db\n
 " > $ans_cfg 

sed -i '/^\s*$/d' $ans_cfg 
echo "Clear ssh known_host"
echo "" > ~/.ssh/known_hosts
echo "Start palbook"
/usr/local/bin/ansible-playbook "$1"
