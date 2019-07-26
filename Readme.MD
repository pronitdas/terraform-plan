


Create a aws account
Create a iam user 


Terraform
> Create EC2 instance
> Configure webserver
> Install ssl certificates
> Configure VPC
> Configure Security groups
> S3 bucket create


Ansible

> Install Prerequisites
> Create a ansible deployer
> Webhooks from github
> Deployment config > Git pull / Dependencies refresh > Config management
> Update s3 bucket for static assets

Code commit
> Webhook configure -> Ansible deploy
> Specific branches

###AWS CLI Commands
aws ec2 describe-images --filters "Name=name,Values=ubuntu*"



Manual Commands 
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash
. ~/.nvm/nvm.sh
nvm install 10.0.0



# Prerequisites
1. Python, Pip installed
2. A ssh key to access repository. ()
    - Bitbucket 

```Steps to move to deploy```
Start with cloning the repository
create virtualenv ```virtualenv env```
switch the working environemnt ```source env/bin/activate```
install pip dependecies ```pip install -r requirements.txt```


## Prerequisite on remote machine
Python should be installed on the machine.

## Setup Host templates
Define API and frontend servers

## deploy.yml || deploy-frontend.yml
- Update branch name that needs to be deployed.

#Before Deploy:
Take a snapshot of the current state of the ec2-container.
Take snapshot of the Database.

## Deploy    
 # API
    from virtualenv execute ```ansible-playbook -i hosts deploy.yml```
    This will setup the code repository from github/bitbucket
    Create virtual env and install pip requirements
    Update Settings.py and wsgi.py
    Run latest migration.
    and restart supervisord.(Currently we have to this step manually)

 # WEB
    from virtualenv execute ```ansible-playbook -i hosts deploy_frontend.yml```

## RollBack

 # API
    Rollback to the snapshot before deploy.
    from virtualenv execute ```ansible-playbook -i hosts rollback.yml```


 # WEB
    from virtualenv execute ```ansible-playbook -i hosts rollback_frontend.yml```














