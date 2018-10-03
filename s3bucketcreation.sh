#!/bin/bash


###This script will help us to create S3 bucket###-----------
###One time runnable script###-------------------------------
###Before running this script you need to configure AWS###---

echo "enter bucket name for Blobstore data"
read S3_BLOBSTORE
aws s3 mb s3://$S3_BLOBSTORE

echo "enter bucket name for ElasticSearch data"
read S3_ELASTIC
aws s3 mb s3://$S3_ELASTIC

echo "enter bucket name for KAFKA data"
read S3_KAFKA
aws s3 mb s3://$S3_KAFKA
 
