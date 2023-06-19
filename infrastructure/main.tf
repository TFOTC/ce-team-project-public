module "network" {
  source = "./modules/network"

  vpc_name = "ce-tfotc-vpc"
}

module "frontend-s3" {
  source = "./modules/frontend-s3"

  bucket_name = "ce-tfotc-frontend-host-fm"
  #bucket_name = "ce-tfotc-frontend-host"
  origin_id   = "ce-tfotc-frontend-host-fm"
  #bucket_name = "ce-tfotc-frontend-host"
}

module "ec2" {
  source = "./modules/ec2"
  
  private_subnet = module.network.private_subnets[0]
  }