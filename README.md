# Install

### Install the offical version from bt.cn first, then update it with the cracked version

```
yum install -y wget && wget -O install.sh http://download.bt.cn/install/install_6.0.sh && sh install.sh ed8484bec
curl https://mod.nde.tw/bt/update.sh|bash
```

### You may also change the source of the script, just upload the files and change the path accordingly

## Guide to use on Google Cloud Platform
```
AAPanel Minimum Requirements

CPU : 1 Core
RAM : 512M or more, 768M or more is recommended (Pure panel for about 60M of system memory)
HDD : More than 100M available hard disk space (Pure panel for about 20M disk space)
Supported OS: CentOS 7.1+ (Ubuntu16.04+., Debian9.0+), to ensure that it is a clean operating system, there is no other environment with Apache/Nginx/php/MySQL installed (the existing environment can not be installed)

{I am Using Cent OS }
Login to your Google Cloud Console.

Create a VM Instance in Compute Engine
Things todo while creating.
i. Allow HTTP and HTTPS Traffic
ii. Add a Tag
iii. All other setting will be default
iv. Create VM instance.

Open required ports in Google Cloud
i. Go to VPC Network -> Firewall
ii. Create a Firewall rule
iii. Open All required Ports (type Ingress)
TCP Ports
443 -https
888 - aapanel
8888 - aapanel
3306 – mysql
53 – DNS
UDP Ports
53 – DNS
iv. Add Target Tag (same while creating VM)
v. Click on Create Button to Proceed

Assign a Static IP to VM Instance
i. Go to VPC Network -> External IP addresses
ii. Assign a Static IP

Now Go to VM instance and Click on SSH on freshly created VM, a New window will open with SSH access to VM.
Now we proceed to install AAPanel
I am Using CentOS, you may proceed with your desired OS installation
https://doc.aapanel.com/web/#/3?page_id=117

Get Root access by typing “sudo –su”

Then
yum install -y wget && wget -O install.sh http://www.aapanel.com/script/install_6.0_en.sh && bash install.sh

Wait to Complete

Profit AAPanel Installed

Login to AAPanel with Credentials provided at Installation Completion on SSH terminal.

Set AAPanel as per your Need ( This may take time)
For more info you may check AAPanel official Docs
https://doc.aapanel.com/web/#/3?page_id=117

Install DNS manager from App Store
(assuming you have already set DNS nameserver point to your server IP from your domain manager i.e. Godaddy, namecheap etc)
i. Add a domain name
ii. Leave SOA if you didn’t know exactly
iii. Add nameserver 1 and nameserver 2
iv. Confirm.

Add website

You are Ready to Go live from AAPanel
Note: You Need to Add Domain in DNS manager too if you want to use multiple domains, enter new domain name and enter nameserver 1 and nameserver 2 which is already assign to your server IP.
AS Google Cloud doesn’t allow port 25, you may follow instructions from google to use mails
https://cloud.google.com/compute/docs/tutorials/sending-mail
```
