# Week 00
### Task
Develop and deploy via AWS CLI CloudFormation script which will create next infrastructure:
- Single EC2 instance
### Solution
1. Crate IAM user with admin permissions and set up AWS Access Key
2. Configure AWS CLI with admin access key `aws configure`
3. Create and save EC2 key pair `aws ec2 create-key-pair --key-name os_admin_key`
4. Deploy cloudformation script with single EC2 instance `aws cloudformation create-stack --stack-name single-ec2-demo-stack --template-body file://week00/BasicEc2.yaml`
5. Validate deployment via ssh connection `ssh -i os_admin_key.pem ec2-user@<public IP from output>`
6. Terminate stack with EC2 instance `aws cloudformation delete-stack --stack-name single-ec2-demo-stack`

