terraform {
  backend "local" {
    path = "./backend/terraform.state"
  }
}