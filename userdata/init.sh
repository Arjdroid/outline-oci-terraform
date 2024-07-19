#!/bin/bash
sudo apt update
sudo apt install -y firewalld
sudo systemctl start firewalld
sudo systemctl enable firewalld
sudo firewall-cmd --zone=public --add-port=443-65535/tcp --permanent
sudo firewall-cmd --reload
