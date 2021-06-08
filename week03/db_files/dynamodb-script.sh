#!/bin/bash
region=us-west-2
table=os-aws-cource-solar-system
itemId=0

echo "List tables:"
aws dynamodb list-tables --region $region

echo "Put items..."
aws dynamodb put-item --region $region --table-name $table --item "{\"id\":{\"N\":\"0\"},\"name\":{\"S\":\"Sun\"},\"radius\":{\"S\":\"695000\"}}"
aws dynamodb put-item --region $region --table-name $table --item "{\"id\":{\"N\":\"1\"},\"name\":{\"S\":\"Mercury\"},\"radius\":{\"S\":\"2439.7 +- 1.0\"}}"
aws dynamodb put-item --region $region --table-name $table --item "{\"id\":{\"N\":\"2\"},\"name\":{\"S\":\"Venus\"},\"radius\":{\"S\":\"6051.8 +- 1.0\"}}"
aws dynamodb put-item --region $region --table-name $table --item "{\"id\":{\"N\":\"3\"},\"name\":{\"S\":\"Earth\"},\"radius\":{\"S\":\"6371.00 +- 0.01\"}}"
aws dynamodb put-item --region $region --table-name $table --item "{\"id\":{\"N\":\"4\"},\"name\":{\"S\":\"Mars\"},\"radius\":{\"S\":\"3389.508 +- 0.003\"}}"
aws dynamodb put-item --region $region --table-name $table --item "{\"id\":{\"N\":\"5\"},\"name\":{\"S\":\"Jupiter\"},\"radius\":{\"S\":\"69911 +- 6*\"}}"
aws dynamodb put-item --region $region --table-name $table --item "{\"id\":{\"N\":\"6\"},\"name\":{\"S\":\"Saturn\"},\"radius\":{\"S\":\"58232 +- 6*\"}}"
aws dynamodb put-item --region $region --table-name $table --item "{\"id\":{\"N\":\"7\"},\"name\":{\"S\":\"Uranus\"},\"radius\":{\"S\":\"25362 +- 7*\"}}"
aws dynamodb put-item --region $region --table-name $table --item "{\"id\":{\"N\":\"8\"},\"name\":{\"S\":\"Neptune\"},\"radius\":{\"S\":\"24622 +- 19*\"}}"

echo "Get item $itemId:"
aws dynamodb get-item --region $region --table-name $table --key "{\"id\":{\"N\":\"$itemId\"}}"

