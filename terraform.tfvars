vpcs = {
  vpc1 = {
    cidr_block = "10.0.0.0/16"
    tags = {
      Name = "hcl-vpc-1"
    }
  }
  vpc2 = {
    cidr_block = "192.168.0.0/16"
    tags = {
      Name = "tcs-vpc-2"
    }
  }
}

subnets = {
  subnet1 = {
    vpc_id     = "vpc1"      #key of vpcs 1 and 2
    cidr_block = "10.0.0.0/24"
    tags = {
      Name = "mysubnet1"
    }
  }
  subnet2 = {
    vpc_id     = "vpc2"
    cidr_block = "192.168.0.0/24"
    tags = {
      Name = "mysubnet2"
    }
  }
}