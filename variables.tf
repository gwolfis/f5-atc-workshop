# Setup file
variable "setupfile" {
  description = "The setup file in yaml format"
  type        = string
  default     = "setup.yml"
}

# Tmp file
variable "tmpfile" {
  description = "The tmp file in yaml format"
  type        = string
  default     = "../files/tmp.yml"
}