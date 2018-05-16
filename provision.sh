#! /bin/bash

#Prompt for profile name
read -rp "Please enter profile name: " PROFILE

#print Account number
aws --profile $PROFILE sts get-caller-identity --output text --query 'Account'

#Create CloudHealth read only policy
aws --profile $PROFILE iam create-policy --policy-name CloudHealthReadOnly --policy-document file://CloudHealthReadOnly.json --description "Provides read-only access to CloudHealth application"
echo -e "\e[44mCloudHealthReadOnly Policy created\e[0m"

#Query for policy ARN for later use
POLICYARN=$(aws --profile $PROFILE iam list-policies --query 'Policies[?PolicyName==`CloudHealthReadOnly`].{Arn:Arn}' --output text)

#Create CloudHealth Role
aws --profile $PROFILE iam create-role --role-name CloudHealth --assume-role-policy-document file://CloudHealth-Trust-Policy.json --description "Used for CloudHealth application"
echo -e "\e[44mCloudHealth role created\e[0m"

#Attach the policy created above to the role created above
aws --profile $PROFILE iam attach-role-policy --role-name CloudHealth --policy-arn $POLICYARN 
echo -e "\e[44mCloudHealthReadOnly policy has been attached to the CloudHealth role\e[0m"

#Output the AWS Console Login page to a file for later use
echo $PROFILE >> consoleURLs.txt
aws --profile $PROFILE sts get-caller-identity --output text --query 'Account' >> consoleURLs.txt

#Print CloudTrail info
aws --profile $PROFILE cloudtrail describe-trails --output table

echo $PROFILE >> cloudtrailARN.txt
aws --profile $PROFILE cloudtrail describe-trails --output table >> cloudtrailARN.txt
echo -e "\e[44mDONE!\e[0m"
