variable "stage" {
  type        = string
  description = ""
}

variable "project" {
  type        = string
  description = ""
}

variable "image_tag_mutability" {
  type        = string
  description = "The tag mutability setting for the repository (defaults to MUTABLE)"
}
