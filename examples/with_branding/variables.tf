variable "user_pool_name" {
  description = "The name of the user pool"
  type        = string
  default     = "example-pool-with-branding"
}

variable "user_pool_tier" {
  description = "The tier of the user pool"
  type        = string
  default     = "ESSENTIALS"
}

variable "domain_name" {
  description = "The domain name for the hosted UI"
  type        = string
  default     = ""
}

variable "enable_branding" {
  description = "Whether to enable managed login branding"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default = {
    Environment = "development"
    Project     = "cognito-branding-example"
  }
}