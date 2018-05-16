#! /bin/bash

#Set environment variable
export AWS_DEFAULT_REGION=us-east-1

#Read list of accounts to apply to 
for PROFILE in $(cat AWS_Accounts.txt)
do

#Create audit role with attached trust policy
aws --profile $PROFILE iam create-policy --policy-name InfosecAudit --policy-document file://InfosecAudit.json --description "Security Policy - Read Only Permissions"
echo -e "\e[44mScout2 Policy created\e[0m"

#Query for policy ARN for later use
POLICYARN=$(aws --profile $PROFILE iam list-policies --query 'Policies[?PolicyName==`InfosecAudit`].{Arn:Arn}' --output text)

#Create audit role
aws --profile $PROFILE iam create-role --role-name InfosecAudit --assume-role-policy-document file://infosec-audit-trust-policy.json --description "Security-role for read-only auditing"
echo -e "\e[44minfosec-audit role created\e[0m"

#Attach policy to role
aws --profile $PROFILE iam attach-role-policy --role-name InfosecAudit --policy-arn $POLICYARN
echo -e "\e[44mScout2 policy attached to infosec-audit role\e[0m"

echo -e "\e[44mDONE!\e[0m"

done
