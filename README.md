* test connection from ansible with the EC2s:
     ansible -i ./hosts.ini control-plane -m ping

* install containerd and k8s:
     ansible-playbook -i hosts.ini containerd-install.yaml
     ansible-playbook -i hosts.ini control-plane.yaml

* create a new certificate to join in the cluster (não use sudo): kubeadm token create --print-join-command

# Start
* terraform apply
* sudo cp ./ansible.cfg /etc/ansible/
* execute ansible/create-ini-file.py
* ansible-playbook -i hosts.ini ./nsible/containerd-install.yaml
* ansible-playbook -i hosts.ini ./ansible/control-plane.yaml
* ansible-playbook -i hosts.ini ./ansible/workers.yaml.yaml
* kubectl label nodes ip-10-0-0-80 node-role.kubernetes.io/worker=
