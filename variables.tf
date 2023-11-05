# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "spotify_api_key" {
  type        = string
  description = "Set this as the APIKey that the authorization proxy server outputs"
}

variable "aws_access_key" {
  type        = string
  description = "Set this as the AWS Access Key"
}

variable "aws_secret_access_key" {
  type        = string
  description = "Set this as the AWS Secret Key"
}
