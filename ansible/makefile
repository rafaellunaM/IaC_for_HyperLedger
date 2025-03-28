CREATE_INI_FILE = python3 create-ini-file.py
CONTAINERD_PLAYBOOK = ansible-playbook -i hosts.ini containerd-install.yaml
CONTROL_PLANE_PLAYBOOK = ansible-playbook -i hosts.ini control-plane.yaml
WORKERS_PLAYBOOK = ansible-playbook -i hosts.ini workers.yaml
CREATE_DISK_PLAYBOOK = ansible-playbook -i hosts.ini create-disk.yaml

ANSIBLE_SSH_ARGS = "-o StrictHostKeyChecking=no"

all: create_ini containerd control-plane workers create-disk

create_ini:
	$(CREATE_INI_FILE)

containerd:
	ANSIBLE_SSH_ARGS=$(ANSIBLE_SSH_ARGS) $(CONTAINERD_PLAYBOOK)

control-plane:
	ANSIBLE_SSH_ARGS=$(ANSIBLE_SSH_ARGS) $(CONTROL_PLANE_PLAYBOOK)

workers:
	ANSIBLE_SSH_ARGS=$(ANSIBLE_SSH_ARGS) $(WORKERS_PLAYBOOK)

create-disk:
	ANSIBLE_SSH_ARGS=$(ANSIBLE_SSH_ARGS) $(CREATE_DISK_PLAYBOOK)

clean:
	rm -f hosts.ini
