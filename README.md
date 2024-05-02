# Follow these steps to set up the automation environment on the Challenge host:

1. Clone this repo to your linux machine
```
git clone https://github.com/TobiOlajumoke/terraform-ansible-project
```

2. Install Terraform and Ansible:

    - Terraform: Download Terraform from the [official website](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) and follow the installation instructions for your operating system.

    - Ansible: Install Ansible using a package manager like apt, yum, or brew. For example, on Ubuntu:
```bash
sudo apt update
sudo apt install ansible
```
or follow their thier offical [website](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#pipx-install)


3. We wanna give terraform permission to write to this `/etc/ansible/hosts` file
if the file doesn't exit create one

    and run this commands:

```
sudo chown $(whoami) /etc/ansible/hosts
sudo chmod u+w /etc/ansible/hosts

```
This command will allow terraform to pass the public ip or the newly created instance into the ansible host file

4. `cd terraform` into Terraform folder
in your main.tf file add the corrrect vaules

```
provider "aws" {
  region = "your_aws_region"
}

resource "aws_security_group" "my_security_group" {
  name        = "my-security-group"
  description = "Security group allowing specified inbound and outbound traffic"
  vpc_id      = "your_existing_vpc_id"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["your_ip_address/32"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["your_ip_address/32"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["ansible_server_ip_address/32"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "my_instance" {
  ami           = "your_ami_id"
  instance_type = "t2.micro"
  subnet_id     = "your_subnet_id"
  key_name = add key name eg "demo_key"

  tags = {
    EnvName = "Test Environment"
  }
  provisioner "local-exec" {
    command = "echo ${aws_instance.my_instance.public_ip} >> /etc/ansible/hosts"
  }
}
```
add your variables, eg to where the red arrow points
![alt text](images/terrafrom_main.png)
![alt text](images/terrafrom_main_contd.png)


5. `cd terraform` into Terraform folder and run the following commands:

```
terraform init
```

```
terraform plan
```
```
terraform apply
```

once your instance is running connect via ssh with your local machine with the ip you specified above:


```
cd .ssh
```
```
ls
```

you should see:
```
authorised keys
```
![alt text](images/rsa.png)

now ssh into the ansible instance:
```
cd .ssh
```

```
vi id_rsa.pub
```
![alt text](images/ansible_server_id_rsa.png)

add copied `id_rsa.pub` key into the authorised key file on our websever instance

```
vi authorised keys
```
paste key there


6. Go into the ansible folder `cd ansible`

run the playbook:
```
ansible-playbook deploy_webapp.yaml
```

you'll get an output like this:
![alt text](<images/run playbook.png>)


Now access the public url of websever instance:

```
http://public_ip_address
```

you'll see something like this:
![alt text](images/public_instance.png)




