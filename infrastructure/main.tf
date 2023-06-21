module "network" {
  source = "./modules/network"

  vpc_name = "ce-tfotc-vpc"
}

module "frontend-s3" {
  source = "./modules/frontend-s3"

  bucket_name = "ce-tfotc-frontend-host"
  origin_id   = "ce-tfotc-frontend-host"
}

module "database" {
  source = "./modules/rds"

  vpc_id         = module.network.vpc_id
  public_subnets = module.network.public_subnets
}


resource "null_resource" "save_database_endpoint" {
  provisioner "local-exec" {
    command = "echo ${module.database.rds_endpoint} > database_endpoint.txt"
  }

  # This dependency ensures that the provisioner runs after the database module has been created
  depends_on = [module.database]
}

module "ecr" {
  source = "./modules/ecr"

  ecr_backend_name = "ce-tfotc-ecr-backend"
}

# module "ec2" {
#   source            = "./modules/ec2"
#   public_subnet_one = module.network.public_subnets[0]
#   public_subnet_two = module.network.public_subnets[1]
#   vpc_id            = module.network.vpc_id
# }

module "eks" {
  source             = "./modules/eks"
  vpc_id             = module.network.vpc_id
  private_subnet_ids = module.network.private_subnets
  cluster_name       = "tfotc-eks-cluster"
}

module "backend-cf" {
  source = "./modules/backend-cf"

  origin_id = "ce-tfotc-backend-host"
}
