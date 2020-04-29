terraform {
  required_version = "~> 0.12"
  backend "remote" {
    organization = "WilsonSo"

    workspaces {
      name = "nightshade-dev"
    }
  }
}

provider "google" {
  credentials = file("keys/terraform-admin.json")
}

provider "google-beta" {
  credentials = file("keys/terraform-admin.json")
}
