with open('../ec2_public_ips.txt', 'r') as file:
    ips = file.readlines()

ips = [ip.strip() for ip in ips]

control_plane_ip = ips[0]
worker_ips = ips[1:]

ini_content = """
[all:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=~/.ssh/id_rsa.pem

[control_plane]
control_plane ansible_host={}

[workers]
""".format(control_plane_ip)

for i, ip in enumerate(worker_ips, 1):
    ini_content += f"worker_{i} ansible_host={ip}\n"

with open('hosts.ini', 'w') as ini_file:
    ini_file.write(ini_content)

print("create hosts.ini with success")
