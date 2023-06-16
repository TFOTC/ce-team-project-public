# Network

This module will create a VPC in the eu-west-2 region with 3 public subnets, and 3 private subnets, one in each of the availability zones. The module will also create all of the necessary gateways and routing tables for internet access. 

## Usage

The module is being used by the **main.tf** file in the root of this directory. You can change the variables by calling them, such as `vpc_name = "my-vpc"`. This module will provide outputs for use by other modules in this directory. 