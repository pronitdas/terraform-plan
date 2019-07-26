data "terraform_remote_state" "infraState" {
   backend = "s3"
   config {
       bucket = "terraform-state-staging"
       key = "network/terraform.tfstate"
       region = "us-east-1"
   }
}
