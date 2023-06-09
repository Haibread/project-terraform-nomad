terraform {
  required_providers {
    scaleway = {
      source = "scaleway/scaleway"
    }
  }
  required_version = ">= 0.13"
}

provider "scaleway"{
    project_id	    = "5cd6941c-6b1d-474a-80c7-1c2ae8ba6719"
    zone            = "fr-par-1"
    region          = "fr-par"
}