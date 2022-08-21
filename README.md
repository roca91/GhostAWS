# Ghost Blog using Terraform on AWS

Terraform module which creates a Ghost deployment on AWS.

## Overview 

Ghost is a free and open source blogging platform and distributed under the MIT License, designed to simplify the process of online publishing for individual bloggers as well as online publications.

This Repo will allow you to deploy an Auto Scaling group and RDS using Terraform for high availability and ease of management. It is free tier eligible if you use the right instance sizes.

## Diagram
![image](https://user-images.githubusercontent.com/6794997/185813163-5ffecd2a-0f09-4266-ba56-ecb75be3e951.png)

# Requirements

* An AWS account
* Terraform v0.14.x

## Usage

* Go to the terraform folder and apply the code
```
cd terraform
terraform init
terraform apply
