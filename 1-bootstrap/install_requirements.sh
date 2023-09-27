#!/usr/bin/env bash

echo "Installing Python dependencies"
python3 -m pip install --user -r requirements.txt

echo "Installing Ansible Galaxy dependencies"
ansible-galaxy install -r requirements.yaml
