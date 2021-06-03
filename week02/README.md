# Week 02
### Task
1. Create an init-s3.sh script which will do the next things:
-	Create a simple small text file
-	Create AWS S3 bucket (via AWS CLI commands)
-	Add versioning to S3 bucket (via AWS CLI commands)
-	Upload file to S3 (via AWS CLI commands)

2. Verify that uploaded file is not publicly available (you could not rich it from your working machine)

3. Create a Cloud Formation script which will deploy the next infrastructure:
-	EC2 instance with access to S3 service.
-	Implement file downloading from S3 bucket during instance startup (bucket and file should be created by init-s3.sh script).
-	Allow HTTP and SSH access to the EC2 instance 
     
4. Create a Terraform scripts which will create infrastructures for Weeks 0, 1, 2

### Solution
1. Run script for create and upload s3 file `$ /bin/bash init-s3.sh`
2. Validate created file access via URL from S3 console Object URL: `https://os-aws-cource-bucket-test.s3-us-west-2.amazonaws.com/hello_file.txt`
3. Deploy cloudformation script for EC2 instance and S3 file `aws cloudformation create-stack --stack-name s3-ec2-demo-stack --region us-west-2 --capabilities CAPABILITY_IAM --template-body file://week02/BasicEc2WithS3.yaml`
4. Validate deployment:
    - Ssh connection: `ssh -i os_admin_key_us2.pem ec2-user@<public IP from aws console>`
    - Check file:
      `[ec2-user@ip-172-31-22-234 ~]$ cat /hello_file.txt
      Hello, world.`
5. Terminate stack with EC2 instance `aws cloudformation delete-stack --stack-name s3-ec2-demo-stack --region us-west-2`

###Terraform
1. Terraform for week00:
- `cd week02/terraform00`
- `terraform init`
- `terraform apply`
- `ssh -i os_admin_key_us2.pem ec2-user@<public IP from output>`
- `terraform destroy`
2. Terraform for week01:
- `cd week02/terraform01`
- `terraform init`
- `terraform apply`
- `ssh -i os_admin_key_us2.pem ec2-user@<public IP from output>`
- `[ec2-user@ip-172-31-41-211 ~]$ java -version
  openjdk version "1.8.0_282"
  OpenJDK Runtime Environment (build 1.8.0_282-b08)
  OpenJDK 64-Bit Server VM (build 25.282-b08, mixed mode)`
- `terraform destroy`
3. Terraform for week02:
- `cd week02/terraform02`
- `terraform init`
- `terraform apply`
- `ssh -i os_admin_key_us2.pem ec2-user@<public IP from output>`
- `[ec2-user@ip-172-31-26-71 ~]$ cat /hello_file.txt
  Hello, world.`
- `terraform destroy`

