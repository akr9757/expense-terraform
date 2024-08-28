#!/bin/bash

yum install ansible python3.11-pip -y &>>/opt/userdata.log
pip3.11 install botocore boto3 &>>/opt/userdata.log
ansible-pull -i localhost -U https://github.com/akr9757/expense-ansible.git -e service_name=${service_name} -e env=${env} expense.yml