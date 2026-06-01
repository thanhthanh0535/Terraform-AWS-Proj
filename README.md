# AWS VPC Infrastructure with Terraform

<<<<<<< HEAD
A Terraform project that provisions a production-ready AWS network layout — VPC, public/private subnets across two AZs, NAT Gateways, a bastion host, tiered security groups, and an encrypted S3 bucket. All resources are tagged consistently and follow AWS security best practices.
=======
A Terraform project that provisions a production-ready AWS network layout — VPC, public/private subnets across two AZs, NAT Gateways, a bastion host, tiered security groups, and an encrypted S3 bucket. 
All resources are tagged consistently and follow AWS security.
>>>>>>> 9c5c4073f45b96726c47d632a7c182de72fb2a7f

---

## Architecture Overview

```
                        ┌─────────────────────────────────────────────┐
                        │                   AWS VPC                    │
                        │               10.0.0.0/16                    │
                        │                                              │
                        │  ┌──────────────┐    ┌──────────────┐       │
Internet ──── IGW ─────►│  │ Public  AZ-1 │    │ Public  AZ-2 │       │
                        │  │ 10.0.1.0/24  │    │ 10.0.2.0/24  │       │
                        │  │  Bastion EC2 │    │   NAT GW     │       │
                        │  └──────┬───────┘    └──────┬───────┘       │
                        │         │ NAT                │ NAT           │
                        │  ┌──────▼───────┐    ┌──────▼───────┐       │
                        │  │ Private AZ-1 │    │ Private AZ-2 │       │
                        │  │ 10.0.10.0/24 │    │ 10.0.11.0/24 │       │
                        │  │  App Servers │    │  App Servers │       │
                        │  └──────────────┘    └──────────────┘       │
                        └─────────────────────────────────────────────┘
```

**Resources provisioned:**

| Resource | Count | Purpose |
|---|---|---|
| VPC | 1 | Isolated network |
| Public Subnets | 2 | Load balancers, bastion |
| Private Subnets | 2 | Application workloads |
| Internet Gateway | 1 | Outbound/inbound for public tier |
| NAT Gateways + EIPs | 2 | Outbound-only for private tier |
| Route Tables | 3 | Public + one per private subnet |
| Security Groups | 2 | Web tier, app tier |
| EC2 Bastion Host | 1 | SSH jump host (Amazon Linux 2023) |
| S3 Bucket | 1 | App assets, versioning + AES-256 |

---

## Prerequisites

<<<<<<< HEAD
- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.3.0
- AWS CLI configured (`aws configure`) with permissions to manage VPC, EC2, S3, and IAM resources
=======
- [Terraform]
- AWS CLI configured
>>>>>>> 9c5c4073f45b96726c47d632a7c182de72fb2a7f
- An existing EC2 key pair in the target region

---

## Usage

**1. Clone the repo**

```bash
git clone https://github.com/<your-username>/terraform-aws-vpc.git
cd terraform-aws-vpc
```

**2. Create your variables file**

```bash
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars and set key_pair_name to your actual key pair
```

**3. Initialize and deploy**

```bash
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

**4. Check outputs**

```bash
terraform output
```

You will see the VPC ID, subnet IDs, bastion public IP, and S3 bucket name.

**5. SSH into the bastion**

```bash
ssh -i ~/.ssh/<your-key>.pem ec2-user@$(terraform output -raw bastion_public_ip)
```

**6. Tear down**

```bash
terraform destroy
```

> ⚠️ This will delete all resources including the NAT Gateways (which incur hourly charges).

---

## Variables

| Name | Default | Description |
|---|---|---|
| `aws_region` | `us-east-1` | AWS region |
| `project_name` | `devops-vpc` | Prefix for all resource names |
| `environment` | `dev` | One of: `dev`, `staging`, `prod` |
| `vpc_cidr` | `10.0.0.0/16` | VPC CIDR block |
| `public_subnet_cidrs` | `["10.0.1.0/24","10.0.2.0/24"]` | Public subnet CIDRs |
| `private_subnet_cidrs` | `["10.0.10.0/24","10.0.11.0/24"]` | Private subnet CIDRs |
| `bastion_instance_type` | `t3.micro` | EC2 instance type for bastion |
| `key_pair_name` | *(required)* | Name of an existing EC2 key pair |

---

## Outputs

| Name | Description |
|---|---|
| `vpc_id` | ID of the VPC |
| `vpc_cidr` | CIDR block of the VPC |
| `public_subnet_ids` | List of public subnet IDs |
| `private_subnet_ids` | List of private subnet IDs |
| `bastion_public_ip` | Public IP of the bastion host |
| `s3_bucket_name` | Name of the app-assets S3 bucket |
| `web_sg_id` | Security group ID — web tier |
| `app_sg_id` | Security group ID — app tier |

---

## Project Structure

```
terraform-aws-vpc/
├── main.tf                  # VPC, subnets, IGW, NAT, SGs, EC2, S3
├── variables.tf             # Input variable definitions
├── outputs.tf               # Output values
├── data.tf                  # Data sources & locals
├── terraform.tfvars.example # Example variable values
├── .gitignore               # Excludes state files and secrets
└── README.md
```

---

## Security Notes

- Private subnets have **no direct internet access** — outbound goes through NAT only
- The bastion security group only opens ports 80/443 as a demo; in production restrict SSH (port 22) to your IP
- The S3 bucket has **public access fully blocked** and server-side encryption enabled (AES-256)
<<<<<<< HEAD
- Terraform state is stored locally by default — for team use, configure an [S3 remote backend](https://developer.hashicorp.com/terraform/language/settings/backends/s3) with DynamoDB locking

---

## Remote State

State is stored remotely in S3 with DynamoDB locking:

| Resource | Name |
|---|---|
| S3 Bucket | `devops-vpc-tfstate-<account-id>` |
| DynamoDB Table | `terraform-state-lock` |
| Encryption | AES-256 |
| Versioning | Enabled |

Configure backend before `terraform init` if deploying to a new environment.

