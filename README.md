# test connection from ansible with the EC2s:
* ansible -i ./hosts.ini control-plane -m ping

# install containerd and k8s:
* ansible-playbook -i hosts.ini containerd-install.yaml
* ansible-playbook -i hosts.ini control-plane.yaml

# Start
* terraform apply
* sudo cp ./ansible.cfg /etc/ansible/
* cd ansible
* python3 create-ini-file.py
* ansible-playbook -i hosts.ini containerd-install.yaml
* ansible-playbook -i hosts.ini control-plane.yaml
* ansible-playbook -i hosts.ini workers.yaml
* ansible-playbook -i hosts.ini creat-disk.yaml

# setup HLF
* cd hyperledger-fabric-k8s
* 

# To Do
* Install ebs aws driver in the k8s cluster and add it on the ansible playbook
* deployment postgres for hyperledger fabric
* deployment components of hyperledger fabric
