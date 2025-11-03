provider "aws" {
    region = "us-east-2"
}

# Steps to import a resource
# 1. Write import block in main.tf
# 2. run plan to generate a tf.
#    ex. terraform plan -generate-config-out=generated.tf
# 3. Examine generated tf
# 4. Copy content of generated tf to main.tf. 
# 5. Remove generated.tf
# 6. Run 'terraform apply'

import {
  to = aws_s3_bucket.s3_import
  id = "tamagawa-terraform-import"
}

# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform from "tamagawa-terraform-import"
resource "aws_s3_bucket" "s3_import" {
  bucket              = "tamagawa-terraform-import"
  bucket_prefix       = null
  force_destroy       = false
  object_lock_enabled = false
  region              = "us-east-2"
  tags = {
    Homework = "9"
  }
  tags_all = {
    Homework = "9"
  }
}
