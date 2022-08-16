terraform {
  backend "remote" {
    organization = "vsnk_shop"

    workspaces {
      name = "stage"
    }
  }

  required_version = ">= 0.14.0"
}
