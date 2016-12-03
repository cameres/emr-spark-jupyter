#!/bin/bash
# bucket should be created and used on s3
SPARK_BUCKET="bucket-to-create-on-s3"
# name of the key pair ex: MyKeyPair
SPARK_KEY_PAIR="key-pair-created-in-first-step"

# create an S3 bucket
aws s3api create-bucket \
--bucket ${SPARK_BUCKET} \
--region us-west-1

# push bootstrap file up to s3
aws s3 cp install-jupyter-notebook s3://${SPARK_BUCKET}/bootstrap/install-jupyter-notebook
# push config for notebook up to s3
aws s3 cp jupyter_notebook_config.py s3://${SPARK_BUCKET}/bootstrap/jupyter_notebook_config.py

# create default roles
aws emr create-default-roles \
  --region us-west-1

# initialize the cluster on amazon
# uses bootstraping for jupyter
aws emr create-cluster --name "Spark Cluster" \
--release-label emr-5.2.0 \
--use-default-roles \
--applications Name=Spark \
--ec2-attributes KeyName=${SPARK_KEY_PAIR} \
--instance-type m3.xlarge	 \
--instance-count 2 \
--region us-west-1 \
--bootstrap-actions Path=s3://${SPARK_BUCKET}/bootstrap/install-jupyter-notebook
