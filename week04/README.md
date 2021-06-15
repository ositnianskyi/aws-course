# Week 04
### Task
1.	Create a Terraform script which will create the next infrastructure:
-	Virtual Public Cloud (VPC) with two subnets private and public, each with one EC2 instance with Apache Web server installed and with simple index.html
-	NAT EC2 instance which will give HTTP access for the private subnet. ATTENTION. AWS suggests to use NAT GATEWAY, but it costs.
-Application Load Balancer targeting to both private and public subnets
2.	Use load balancer HTTP URL to check your solution - load balancer should return as a response these pages per extern HTTP-request. So you have to see pages from both servers.

### Solution
- `cd week04`
- `terraform init`
- `terraform apply`
  `Outputs:
lb_dns_name = "alb-lb-2124393938.us-west-2.elb.amazonaws.com"
private_instance_private_ip = "10.0.2.102"
public_instance_public_ip = "52.33.244.114"`
- Open http://alb-lb-2124393938.us-west-2.elb.amazonaws.com/ result:
  `This is WebServer from public subnet` or `This is WebServer from private subnet`
- `terraform destroy`