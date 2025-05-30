terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "lb-aws-admin"
}

module "apache" {
  source             = "./terraform-aws-apache-example"
  vpc_id             = "vpc-0cd1d459812cff83a"
  my_ip_with_cidr    = "172.31.0.0/16"
  public_key         = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQChwq0wQ2PGtWN+Giq/o+qdxzGwweFNm2L+oehCB+RSon+EXVm+Vnj1nEFUnXIVvXHY1Yx0GhP3RMAgQxUaaE2Qe2adoiQ502BceWuxQdINNQxfWkBWAXhFshly0XCb/siLFZP+WOMS9K+2qwImPphjZnIATe6mwrFnoWm22xTmO3E+bgz7VTc0ofnNA5xGh7quOYOtutzC/ouxg9+c+9dAEtEblPYt1374kRMQgqDzvpa6WFHirvgWtdoI/7fBFuJPhJau3BcatCwmUwf421LklycIRBmPL8FWp+3AfK2ng6Ap2FMT9mWY7kAfnjx/sRFgOvMjcc3bz/freTmPI6qgcz9xR4/lMA/AIUvqdezr6OHy1dy4j8am4ikmWo8tAVLSCvzuouGmS1COIvn5qXqYRZ96a9hCItDYByzIt+TN0RQ3Oq6QGFVh/xM5yBKBAalqVHwWz/QdfZNQoZooinWgvypyWMEU0VZxEj/aNxsc39GYUZ37qBzOVxe/26xNHxv+OMl1GUhgHkKzc3/xIq1wKTR6wlrrXEM03IZUC454HJcHRsH3+WZmV+U+ko4V/8gkCIwye9gfDLyV8q0g/Yka56+A3hjOcI3TUFnuwLjyFAy/B841LUjO72ySFf0Q5s9KJxu2zbjmneh3OsDR4vnpSBClxe7xf+THwKSV1si50w== luca.bigoni@gmail.com"
  instance_type      = "t2.micro"
  server_name        = "Apache Example Server"
}

output "public_ip" {
  description = "Public IP of the Apache instance"
  value       = module.apache.public_ip
}