# Schedemy Infrastructure (IaC)

This repository contains the **Infrastructure as Code (IaC)** configurations for the **Schedemy** graduation project. It uses **Terraform** to provision a highly available, secure, and scalable environment on AWS.

## 🏗 Architecture Overview

The infrastructure is deployed in the `eu-north-1` region and consists of:
* **Networking:** Custom VPC with public subnets across 2 Availability Zones.
* **Compute:** Auto Scaling Group (ASG) launching EC2 instances from a Golden AMI.
* **Traffic Management:** Application Load Balancer (ALB) with SSL termination.
* **Performance:** CloudFront CDN for global caching and low latency.
* **Security:** IAM Roles (SSM) and strict Security Groups.
* **Monitoring:** CloudWatch Dashboards and SNS Alerts.

## 🚀 Prerequisites

To deploy this infrastructure, you need:
* [Terraform](https://www.terraform.io/downloads.html) installed (v1.0+).
* AWS CLI configured with appropriate credentials.

## 🛠 Deployment Steps

1.  **Initialize Terraform:**
    ```bash
    terraform init
    ```

2.  **Review the Plan:**
    ```bash
    terraform plan
    ```

3.  **Apply Changes:**
    ```bash
    terraform apply --auto-approve
    ```

## 📂 File Structure

* `vpc.tf`: Network Layer (VPC, Subnets, IGW).
* `securitygr.tf`: Security Groups (Firewalls).
* `alb.tf`: Load Balancer & Target Groups.
* `asgl.tf`: Auto Scaling & Launch Templates.
* `cloudfront.tf`: CDN Distribution.
* `monitoring.tf`: CloudWatch & SNS.
* `variables.tf`: Input variables.

---
*© 2024 Schedemy Project Team.*
