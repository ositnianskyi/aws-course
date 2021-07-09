# Week 05
### Task
Create a Terraform script which will generate and deploy next infrastructure:
- VPC with four subnets (two public, two private).
- ASG with minimum two EC2 instances (one EC2 instance per each public subnet). EC2 instances in public subnets should have SSH/HTTP/HTTPS access from all IPs.
- NAT EC2 instance (aka Bastion) in public subnet.
- C2 instance in one of the private subnets. Private EC2 should have SSH access from public subnets only. Implement ability to download software from the internet using created NAT EC2 instance.
- All EC2 instances (except of NAT EC2) both public/private should have java8 installed during instance creation.
- DynamoDB database with next parameters (EC2 instances should have permissions to access DynamoDB table):
 TableName: edu-lohika-training-aws-dynamodb
 Field: UserName, type: rds.tf
- Postgres RDS with next parameters (only private subnets should have access to the RDS instance) Please not that you need to create RDS instance in VPC (in private subnets).
 DBName: EduLohikaTrainingAwsRds
 Port: 5432
 User/password: rootuser/rootuser
 (you don’t need to define a schema; it will auto generating)
- SNS topic with the next name – edu-lohika-training-aws-sns-topic
- SQS queue with the next name – edu-lohika-training-aws-sqs-queue
- LoadBalancer with 80 port targeting to public EC2 instances.
- Health check for ELB: /actuator/health
- Run into public subnet:
 calc-0.0.1-SNAPSHOT.jar
- Run into private subnet:
 persist3-0.0.1-SNAPSHOT.jar
 set environment variable RDS_HOST with correct RDS address
- On your local machine, you need to have java 8.
- On your local machine execute:
 java -cp calc-client-1.0-SNAPSHOT-jar-with-dependencies.jar CalcClient <ELB’s DNS name>

### Solution
- `cd week06`
- `terraform init`
- `terraform apply`
  `Outputs:
lb_dns_name = "web-elb-1305771910.us-west-2.elb.amazonaws.com"
private_instance_private_ip = "10.0.3.55"
sns = "arn:aws:sns:us-west-2:260717713138:edu-lohika-training-aws-sns-topic"
`
- Test calc client app: `./calc_client.sh`
- Ssh to ec2 instance: `ssh -i /Users/ositnianskyi/AWS-course/os_admin_key_us2.pem ec2-user@52.37.137.237`
- Test Dynamodb: `[ec2-user@ip-10-0-3-55 ~]$ aws dynamodb list-tables --region us-west-2
  {
  "TableNames": [
  "edu-lohika-training-aws-dynamodb"
  ]
  }`
  `[ec2-user@ip-10-0-2-30 ~]$ aws dynamodb scan --region us-west-2 --table-name edu-lohika-training-aws-dynamodb
  {
  "Count": 13,
  "Items": [
  {
  "UserName": {
  "S": "N12WN"
  }
  },
  {
  "UserName": {
  "S": "MZ9O0"
  }
  },
  {
  "UserName": {
  "S": "VC4GO"
  }
  },
  {
  "UserName": {
  "S": "GWW7V"
  }
  },
  {
  "UserName": {
  "S": "5T0RL"
  }
  },
  {
  "UserName": {
  "S": "IUL90"
  }
  },
  {
  "UserName": {
  "S": "LZR67"
  }
  },
  {
  "UserName": {
  "S": "FWXWN"
  }
  },
  {
  "UserName": {
  "S": "MT5IA"
  }
  },
  {
  "UserName": {
  "S": "DBJSP"
  }
  },
  {
  "UserName": {
  "S": "AYJDP"
  }
  },
  {
  "UserName": {
  "S": "RRPO9"
  }
  },
  {
  "UserName": {
  "S": "9PKFE"
  }
  }
  ],
  "ScannedCount": 13,
  "ConsumedCapacity": null
  }
  `
- Test RDS: `cd /`
  `psql -h terraform-20210709102337101100000001.cqgpc4daug2v.us-west-2.rds.amazonaws.com -p 5432 -U rootuser -d rootuser -a -f get_logs.sql`
  `Password for user rootuser:
  SELECT * FROM LOGS;
  line
15+38                                             
14+58                                             
22+67                                             
48+62                                             
0+71                                              
61+70                                             
(6 rows)`
- `terraform destroy`