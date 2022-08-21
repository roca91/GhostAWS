/*--------------------------------------------------------------------------------------------------
  Global Variables
--------------------------------------------------------------------------------------------------*/

variable "region" {
  description = "Region where the resources will be deployed"
  type        = string
  default     = "eu-central-1"
}

variable "tags" {
  description = "Global tags applied to every resource by default"
  default = {
    Terraform = "true"
    Company   = "DroneShuttleLtd"
    Project   = "Ghost-Blog"
  }
}

/*--------------------------------------------------------------------------------------------------
  VPC
--------------------------------------------------------------------------------------------------*/

variable "vpc_name" {
  description = "VPC name"
  type        = string
  default     = "dsl_vpc_ghost_prod"
}

variable "vpc_cidr" {
  description = "VPC CIDR range"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "Availability Zones"
  type        = list(string)
  default     = ["eu-central-1a", "eu-central-1b"]
}

variable "public_subnets" {
  description = "Public subnets where the ghost instances will be deployed"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "private_subnets" {
  description = "Private subvnets where the RDS instance will be deployed"
  type        = list(string)
  default     = ["10.0.20.0/24", "10.0.21.0/24"]
}

/*--------------------------------------------------------------------------------------------------
  RDS
--------------------------------------------------------------------------------------------------*/

variable "mysql_engine_version" {
  description = "MySQL engine version"
  type        = string
  default     = "8.0"
}

variable "mysql_instance_class" {
  description = "MySQL instance class"
  type        = string
  default     = "db.t2.micro"
}

variable "mysql_name" {
  description = "MySQL database name"
  type        = string
  default     = "ghostdb"
}

variable "mysql_username" {
  description = "MySQL admin username"
  type        = string
  default     = "admin"
}

variable "mysql_password" {
  description = "MySQL password"
  type        = string
  default     = "ghostadmindbpass##1"
}

variable "mysql_parameter_group_name" {
  description = "MySQL parameter group name"
  type        = string
  default     = "default.mysql8.0"
}

/*--------------------------------------------------------------------------------------------------
  EC2 / ASG
--------------------------------------------------------------------------------------------------*/

variable "ec2_instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "asg_max_size" {
  description = "ASG maximum instance count"
  type        = string
  default     = 5
}

variable "asg_min_size" {
  description = "ASG minumum instance count"
  type        = string
  default     = 1
}


/*--------------------------------------------------------------------------------------------------
  S3
--------------------------------------------------------------------------------------------------*/

variable "s3bucketname" {
  description = "S3 Bucket name for the content of Ghost"
  type = string
  default = "dsl-ghost-content-bucket"
}

/*--------------------------------------------------------------------------------------------------
  User data vars
--------------------------------------------------------------------------------------------------*/

variable "website_url" {
  description = "Ghost website URL"
  type        = string
  default     = ""
}

variable "website_admin_url" {
  description = "Ghost website admin URL"
  type        = string
  default     = ""
}