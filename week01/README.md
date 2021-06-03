# Week 01
### Task
Develop and deploy via AWS CLI CloudFormation script which will create next infrastructure
- Auto-scaling group (ASG) with two EC2 instances within it (we need to ensure that min amount of instances in the ASG is 2)
- Allow SSH and HTTP access to EC2 instances
- Add the ability for EC2 instances to install Java 8 during startup

### Solution
1. Deploy cloudformation script with single EC2 instance `aws cloudformation create-stack --stack-name auto-scale-ec2-demo-stack --template-body file://week01/BasicEc2AutoScaling.yaml`
2. Validate deployment: 
   - Ssh connection: `ssh -i os_admin_key.pem ec2-user@<public IP from aws console>`
   - Java vesion:
    `[ec2-user@ip-172-31-25-66 ~]$ java -version
     openjdk version "1.8.0_282"
     OpenJDK Runtime Environment (build 1.8.0_282-b08)
     OpenJDK 64-Bit Server VM (build 25.282-b08, mixed mode)`
   - Terminate EC2 instance and check creating new instance according to Auto-scaling rule
3. Terminate stack with EC2 instance `aws cloudformation delete-stack --stack-name auto-scale-ec2-demo-stack`

