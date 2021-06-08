# Week 03
### Task
1.	Create a simple SQL script rds-script.sql which will perform next things:
-	Database creation
-	Creation of one simple table for tests
-	Adding some dummy data to the table
-	A simple select statement which will return all entries from the table
2.	Create a simple dynamodb-script.sh which will do the next things (via AWS CLI commands):
-	Display existing Dynamo DB tables
-	Add a few entries in the table
-	Read entries from the table
3.	Create a init-s3.sh script which will do the next things:
-	Create AWS S3 bucket
-	Upload the rds-script.sql and the dynamodb-script.sh to an S3 bucket
4.	Create a Terraform script which will create the next infrastructure:
-	One Dynamo DB table
-	One RDS database (postgres)
-	Create an EC2 instance with all needful access permissions (to S3, DynamoDB and RDS)
-	All scripts from S3 should be copied to the instance during startup
-	Add access permissions for HTTP, SSH, and to selected RDS database
-	An RDS endpoint and port should be available in the script output
-	As usual please put as much customization as possible via input variables to the script
5.	SSH to a created EC2 instance and execute both scripts in order to test your solution

### Solution
- `cd week03`
- `terraform init`
- `terraform apply`
  `instance_public_ip = "34.219.9.94"
  rds_endpoint = "terraform-20210608181821009600000001.cqgpc4daug2v.us-west-2.rds.amazonaws.com:5432"
  rds_port = 5432`
- `ssh -i os_admin_key_us2.pem ec2-user@<public IP from output>`
- `[ec2-user@ip-172-31-31-119 ~]$ cd /init_files`
`[ec2-user@ip-172-31-31-119 init_files]$ ./dynamodb-script.sh
  List tables:
  {
  "TableNames": [
  "os-aws-cource-solar-system",
  "os-aws-cource-test-db-1"
  ]
  }
  Put items...
  Get item 0:
  {
  "Item": {
  "radius": {
  "S": "695000"
  },
  "id": {
  "N": "0"
  },
  "name": {
  "S": "Sun"
  }
  }
  }
  `
-`[ec2-user@ip-172-31-31-119 init_files]$ psql -h terraform-20210608181821009600000001.cqgpc4daug2v.us-west-2.rds.amazonaws.com -p 5432 -U postgres -f rds-script.sql
  Password for user postgres:
  CREATE DATABASE
  CREATE TABLE
  INSERT 0 1
  INSERT 0 1
  INSERT 0 1
  INSERT 0 1
  INSERT 0 1
  INSERT 0 1
  INSERT 0 1
  INSERT 0 1
  INSERT 0 1
  id |  name   |      radius       
  ----+---------+-------------------
  0 | Sun     | 695000
  1 | Mercury | 2439.7 +- 1.0
  2 | Venus   | 6051.8 +- 1.0
  3 | Earth   | 6371.00 +- 0.01
  4 | Mars    | 3389.508 +- 0.003
  5 | Jupiter | 69911 +- 6*
  6 | Saturn  | 58232 +- 6*
  7 | Uranus  | 25362 +- 7*
  8 | Neptune | 24622 ± 19*
  (9 rows)
  `
- `terraform destroy`