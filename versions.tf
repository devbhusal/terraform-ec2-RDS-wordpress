terraform {
  required_providers {
    aws = {
      version = "~>4.30.0"
    }
    null = {
      version = "~> 3.1.1"
    }
    template ={
       version= "~> 2.2.0"       

    }
  }

  required_version = "~> 1.1.3"
}