# Elements Community Edition on AWS

This project provides **Infrastructure as Code** using **Terraform** to deploy and configure an EC2 instance running the [Docker Compose Community Edition](https://github.com/NamazuStudios/docker-compose) distribution of Elements.

The deployment includes:

* EC2 instance in a default VPC  
* Application Load Balancer with SSL  
* EBS volumes for persistent data storage  
* Automated mounting and formatting of volumes  
* Retrieval of configuration secrets from AWS Secrets Manager  
* Systemd-managed Docker Compose services

---

