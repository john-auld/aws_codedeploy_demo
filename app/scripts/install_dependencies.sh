#!/bin/bash

{
	grep -q "CentOS Linux release 7" /etc/redhat-release
} || {
    echo This is not a CentOS 7 node. Installation halted.
	exit 1
}

(    # Setup Ansible venv
    export PATH=${PATH}:/root/.local/bin
    pip install virtualenv --user
    virtualenv /root/codedeploy-venv
) && (
    # Install Ansible
    source /root/codedeploy-venv/bin/activate
    pip install pip --upgrade
    pip install ansible==2.7.5
    chmod +x /root/codedeploy-venv/bin/ansible*
)