cat > README.md << 'EOF'
# 📘 Elements Community Edition on AWS - Terraform Deployment

This project deploys **Elements Community Edition** on AWS using Terraform and Docker Compose.
It automates the provisioning of all required AWS infrastructure and installs the Elements Community Edition application in a Dockerized environment.

---

## 🚀 Features

- Creates AWS infrastructure:
    - VPC
    - Security Group
    - EC2 instance
    - Route53 record for public access
- Installs Docker and Docker Compose
- Deploys Elements Community Edition containers automatically
- Outputs the public URL to access the application

---

## 🛠 Prerequisites

Before using this project, ensure you have:

- [Terraform](https://www.terraform.io/downloads.html) installed (v1.0+ recommended)
- An AWS account with sufficient permissions to create:
    - EC2 instances
    - Networking resources
    - IAM resources (if applicable)
    - Route53 Entries in an existing hosted ZONE.
- Your AWS credentials configured in your environment (e.g., via `aws configure` or environment variables)
- You must have a Route53 Hosted Zone already up and running and accessible to the public as SSL validation requires a public domain.

---

## ⚙️ Usage

Follow these steps to deploy Elements Community Edition:

1. **Clone the Repository**

   ```bash
   git clone https://github.com/NamazuStudios/community-edition-aws.git
   cd community-edition-aws
   ```
   
2. **Initialize Terraform**

   ```bash
   terraform init
   ```
   
3. **Customize Variables**

Create a `terraform.tfvars` file in the root directory with your specific configuration. Here’s an example:

```hcl
aws_profile        = "default"
deployment_name    = "my-deployment"
hosted_zone_id     = "Z3ABCDEFGEXAMPLE"
hosted_zone_name   = "example.com."
```

4. **Plan the Deployment**

   ```bash
   terraform plan -var-file terraform.tfvars 
   ```

5. **Apply the Deployment**

   ```bash
   terraform apply -var-file terraform.tfvars 
   ```

   Confirm the action when prompted.

---

## Terraform Variables

### ✅ Required Variables

- **`aws_profile`**  
  The locally configured AWS Profile to use for auth.

- **`deployment_name`**  
  The name for this deployment which also defines the DNS prefix.

- **`hosted_zone_id`**  
  The Route53 Hosted Zone ID.

- **`hosted_zone_name`**  
  The domain name of the Hosted Zone (e.g., example.com.).

### All Supported Variables

| Variable Name                | Type   | Default Value                                           | Description                                                     |
| ---------------------------- | ------ | ------------------------------------------------------- | --------------------------------------------------------------- |
| `aws_region`                 | string | `"us-east-1"`                                           | The AWS region to operate against.                              |
| `aws_profile`                | string | *n/a*                                                   | The locally configured AWS Profile to use for auth.             |
| `availability_zone`          | string | `"us-east-1a"`                                          | The Availability Zone to deploy into.                           |
| `deployment_name`            | string | *n/a*                                                   | The name for this deployment which also defines the DNS prefix. |
| `ssh_public_key_file`        | string | `"ssh_key.pub"`                                         | The public key contents.                                        |
| `ami`                        | string | `"ami-05ffe3c48a9991133"`                               | The AMI for the instance. Must be Amazon Linux 2023 or later.   |
| `instance_type`              | string | `"t3.micro"`                                            | The machine type.                                               |
| `root_block_device_size`     | number | `64`                                                    | The size of the root block device.                              |
| `db_volume_size`             | number | `8`                                                     | The size of the database volume in GB.                          |
| `log_volume_size`            | number | `16`                                                    | The size of the log volume in GB.                               |
| `repository_volume_size`     | number | `16`                                                    | The size of the repository volume in GB.                        |
| `hosted_zone_id`             | string | *n/a*                                                   | The Route53 Hosted Zone ID.                                     |
| `hosted_zone_name`           | string | *n/a*                                                   | The domain name of the Hosted Zone (e.g., example.com.).        |
| `repo_tag`                   | string | `"3.2.0-deployment"`                                    | Git tag to check out.                                           |
| `repo_url`                   | string | `"https://github.com/NamazuStudios/docker-compose.git"` | Git repo URL.                                                   |
| `prevent_volume_destruction` | bool   | `true`                                                  | If true, prevents the destruction of the volumes.               |


## 🌐 Accessing the Application

After Terraform completes, it will output the **public DNS name** of the EC2 instance.

Example output:

Open your browser and navigate to: ```https://<deployment-name>.example.com/admin```

You should see the Elements Community Edition interface.

---

## 🧹 Destroying the Deployment

To remove all resources created by this project:

```bash
terraform destroy
```

Confirm when prompted. 
⚠️ **Warning:** This action is irreversible and will delete your EC2 instance and associated resources.

---

## 📝 License

This project is licensed under the MIT License. See [LICENSE](LICENSE.txt) for details.
EOF

---

## Troubleshooting

### No Default VPC

By default, AWS accounts do not create a default VPC, which will produce this message:

```aiignore
Error: no matching EC2 VPC found
│ 
│   with data.aws_vpc.default,
│   on vpc.tf line 3, in data "aws_vpc" "default":
│    3: data "aws_vpc" "default" {
```

To fix this you must create a VPC:
```bash
aws ec2 create-default-vpc
```
