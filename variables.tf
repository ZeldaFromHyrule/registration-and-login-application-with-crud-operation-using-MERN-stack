variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "mern-app-rg"
}

variable "location" {
  description = "Azure region where resources will be deployed"
  type        = string
  default     = "westus2"
}

variable "acr_name" {
  description = "Name of the Azure Container Registry"
  type        = string
  default     = "mernappacr"
}

variable "log_analytics_name" {
  description = "Name of the Log Analytics workspace"
  type        = string
  default     = "mern-log-workspace"
}

variable "container_app_env_name" {
  description = "Name of the Container App Environment"
  type        = string
  default     = "mern-container-env"
}
