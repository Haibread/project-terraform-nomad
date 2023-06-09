variable "server_count" {
  default     = "3"
  description = "The number of nomad servers to launch."
}

variable "image" {
    default     = "ubuntu_jammy"
    description = "The image to use."
}

variable "instance_type" {
  default     = "DEV1-L"
  description = "Scaleway instance type to use"
}