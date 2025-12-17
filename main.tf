module "my_network" {
    source = "./modules/aws-vpc-tf"
    vpc_name = "sample-demoVPC"
    vpc_cidr_block = "192.168.0.0/16"
    availability_zones = ["eu-west-2a", "eu-west-2b"]
    public_subnet_cidrs = ["192.168.1.0/24", "192.168.3.0/24"]
    private_subnet_cidrs =["192.168.2.0/24", "192.168.4.0/24"]
}

resource "aws_security_group"  "demo-sg"{
    name = "demo-ec2-secutiry-grps"
    description = "Allow SSH and HTTP inbound traffic"
    vpc_id =  module.my_network.vpc_id
    ingress {
       from_port = 22
       to_port = 22
       protocol = "tcp"
       cidr_blocks = ["0.0.0.0/0"]
    }

     ingress {
       from_port = 80
       to_port = 80
       protocol = "tcp"
       cidr_blocks = ["0.0.0.0/0"]
    }  

}