* test connection from ansible with the EC2s:
     ansible -i ./hosts.yaml control-plane -m ping

* install containerd and k8s:
     ansible-playbook -i hosts.yaml containerd-install.yaml
     ansible-playbook -i hosts.yaml k8s-install.yaml 