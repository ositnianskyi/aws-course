#!/bin/bash
lb=web-elb-1662839767.us-west-2.elb.amazonaws.com

java -cp jars/calc-client-1.0-SNAPSHOT-jar-with-dependencies.jar CalcClient $lb