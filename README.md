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

### 🛠️ Setting up a Route 53 Hosted Zone

To use this module effectively, you’ll need an [Amazon Route 53](https://aws.amazon.com/route53/) hosted zone for your domain. Here’s a quick guide to create one:

1. **Sign in to the AWS Console**  
   Open the [Route 53 Console](https://console.aws.amazon.com/route53/).

2. **Navigate to Hosted Zones**  
   In the navigation pane, choose **Hosted zones**, then click **Create hosted zone**.

3. **Create the Hosted Zone**
    - **Domain Name:** Enter the domain you want to manage (e.g., `example.com`).
    - **Type:** Choose **Public Hosted Zone** (unless you need a private zone for VPC).
    - **Comment:** (Optional) Add a description.
    - **VPC ID:** Leave blank for public zones.

4. **Click Create Hosted Zone**

Once created, note down the **Hosted Zone ID** and **Name Servers**—you’ll need them to configure DNS records and delegate your domain.

For full details, refer to the official AWS documentation:  
👉 [Creating a Public Hosted Zone](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/CreatingHostedZone.html)

### 🔐 Generating an SSH Key

You need an SSH key pair to securely access your resources (e.g., EC2 instances, Git repositories). Follow the steps for your operating system:

⚠️ *SSH Keys can give anyone full access to your server. Take care not to check them in to git or share them.*

---

#### 🐧 Unix / macOS

1. **Open a terminal.**
2. **Generate the SSH key pair and save it to a custom filename (`ssh_key`):**

   ```bash
   ssh-keygen -t rsa -b 4096 -C "your_email@example.com" -f ssh_key
   ```

    - This command creates:
        - The **private key**: `~/.ssh/ssh_key`
        - The **public key**: `~/.ssh/ssh_key.pub`
    - Choose a passphrase (optional but recommended).

3. **Add your SSH key to the SSH agent:**

   ```bash
   eval "$(ssh-agent -s)"
   ssh-add ssh_key
   ```

4. **Copy your public key to paste into AWS, GitHub, or other services:**

   ```bash
   cat ~/.ssh/ssh_key.pub
   ```

   ⚠️ *Terraform will reference this public key file (`ssh_key.pub`) when creating the instance.*

For more details, see [GitHub: Generating a new SSH key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key).

---

#### 🪟 Windows (Using PuTTYgen and Pageant)

1. **Download and install [PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html).**
2. **Open *PuTTYgen*.**
    - Type of key: **RSA**
    - Number of bits: **4096**
3. **Click *Generate*.**
    - Move your mouse around in the blank area to generate randomness.
4. **Save the keys:**
    - Click **Save private key** (you can set a passphrase).
    - **Save the public key** to a file named `ssh_key` (without any extension).  
      ⚠️ *This file will be referenced by Terraform when creating the instance.*
    - Optionally, copy the public key text in the window if needed.

5. **Load the private key into Pageant:**
    - Start **Pageant** (included with PuTTY).
    - Right-click the Pageant icon in the system tray.
    - Select **Add Key** and choose your `.ppk` private key file.

For more information, see:
- [PuTTYgen Documentation](https://the.earth.li/~sgtatham/putty/0.78/htmldoc/Chapter8.html)
- [Using Pageant for SSH Authentication](https://the.earth.li/~sgtatham/putty/0.78/htmldoc/Chapter9.html)


---

## ⚙️ Deploying

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
hosted_zone_name   = "example.com"
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
  The domain name of the Hosted Zone (e.g., example.com).

### All Supported Variables

| Variable Name                | Type   | Default Value                                           | Description                                                    |
| ---------------------------- | ------ | ------------------------------------------------------- | -------------------------------------------------------------- |
| `aws_region`                 | string | `"us-east-1"`                                           | The AWS region to operate against.                             |
| `aws_profile`                | string | *n/a*                                                   | The locally configured AWS Profile to use for auth.            |
| `availability_zone`          | string | `"us-east-1a"`                                          | The Availability Zone to deploy into.                          |
| `deployment_name`            | string | *n/a*                                                   | The name for this deployment which also defines the DNS prefix. |
| `ssh_public_key_file`        | string | `"ssh_key.pub"`                                         | The public key contents.                                       |
| `ami`                        | string | `"ami-05ffe3c48a9991133"`                               | The AMI for the instance. Must be Amazon Linux 2023 or later.  |
| `instance_type`              | string | `"t3.micro"`                                            | The machine type.                                              |
| `root_block_device_size`     | number | `64`                                                    | The size of the root block device.                             |
| `db_volume_size`             | number | `8`                                                     | The size of the database volume in GB.                         |
| `log_volume_size`            | number | `16`                                                    | The size of the log volume in GB.                              |
| `repository_volume_size`     | number | `16`                                                    | The size of the repository volume in GB.                       |
| `hosted_zone_id`             | string | *n/a*                                                   | The Route53 Hosted Zone ID.                                    |
| `hosted_zone_name`           | string | *n/a*                                                   | The domain name of the Hosted Zone (e.g., example.com).        |
| `repo_tag`                   | string | `"3.2.0-deployment"`                                    | Git tag to check out.                                          |
| `repo_url`                   | string | `"https://github.com/NamazuStudios/docker-compose.git"` | Git repo URL.                                                  |


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

## Accessing your Server

Once you have launched your instance, you can access it by SSH to perform tasks such as restarting the instance. To
do this, use the SSH key you generated earlier:

```bash
ssh -i ssh_key ec2-user@<deployment-name>-ssh.example.com
```

If you used the SSH Agent, you can simply use:

```bash
ssh ec2-user@<deployment-name>-ssh.example.com

---

### Restarting Elements

Elements runs as a Docker Compose application managed by systemd, you can restart it with:

```bash
sudo service elements restart
```

### Starting and Stopping Elements

Starting and stopping happens with the following commands:

```bash
sudo service elements stop
```

```bash
sudo service elements start
```

### Accessing Logs

Logs for Elements live in two locations. One is the output of Docker when the containers are building and starting, this
can be accessed with:

```bash
sudo journalctl -u elements
```

Once it's up and running application logs are stored in the `/var/log/elements` directory. You can view them with:

```bash
tail -f /mnt/logs/elements.log
```

You can also copy logs to your local machine using SCP

```bash
scp -r ec2-user@<deployment-name>-ssh.example.com:/mnt/logs
```

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
