module "network" {
  source = "./modules/network"

  vpc_name = "ce-tfotc-vpc"
}

module "frontend-s3" {
  source = "./modules/frontend-s3"

  bucket_name = "ce-tfotc-frontend-host"
  origin_id   = "ce-tfotc-frontend-host"
}
