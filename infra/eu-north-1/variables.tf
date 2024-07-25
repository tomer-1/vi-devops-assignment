variable "services" {
  description = "list of services running in k8s"
  type        = list
  default     = ["service1" , "service2"]
}
