## DevOps Engineer Home Assignment - solution


# requirements

1. terraform installed - used v1.9.3
2. docker (or other alternative like podman) installed - used the community version 25.0.2
3. aws credentials setup
4. aws configured to output as json
5. kubectl installed - used v1.28.2
6. helm installed - used v3.15.3


# there were 5 parts to this solution

1. the fundamental infrastructure for hosting the solution. (using terraform) - eks cluster
2. making the code run containerized (using docker)
3. run the containers in the created cluster (using helm+nodejs+terraform) - required adjusting the code to enable health-check endpoints, required adding coredns addon to the cluster
4. run mongodb inside the cluster (using helm) - storage was set to ephemeral due to time constrains
5. enable internet access to the applications (using aws load balancer controller helm version + terraform)

# issues i've encountered during the assignment.
1. mongodb cannot run on graviton instances - i've first used graviton instances for the main node group , but after trying to run mongo i've realized it's not working on ARM, so had to switch the node group arch and ami (it is possible to split into two node groups (app + infra) which is also good practice, but this would have required addition configurations at the nodes + charts which i didn't want to waste too much time on). in a real world schenario it's mostly preferrable to use graviton
2. if using an internal mirror docker repository in the vpc, one can run instances running for example mongo in an intranet subnet (no internet access)
3. the mongodb chart from bitnami requires a persistant volume by default, which is reasonable for a database.. which made me explore into deploying an EBS CSI driver for that matter matter, only to later find out there is a way to force the use of ephemeral storage, which i had to setup due to time constains althought this is not something i would have implemented in the first place.
4. at first i started the cluster using nano and micro instances... which didn't work for 2 reasons.
   - nano instances cannot host mongoDB, mongo requires a minimum of 500Mib to run, but micro instance has a total of 500MG of memory to start with, so no matter how many nano instances you'll have , you will never be able to accomodate a mongoDB
   - from my testing, micro instances were not able to join the cluster, i don't know why yet , i started debugging this, tried various simple method with no success...
   the best way to debug this would be to just connect to the nodes and check, but for that the nodes need to have password login enabled or have an ssh keypair assigned, which i didn't have time to get into so i just increased the size to make it work.
5. coredns is essential in order to connect to mongodb via dns so it had to be installed
6. in order to allow the ALB controller to work properly and expose the service to the world i've had to set up an IAM role and policy and attach it using the "IAM role for service account" method


### in order to run the solution

## 1. build the environment.
from the main directoy go into the terraform directory
``` cd infra/eu-north-1
```

run terraform
```
terraform init
terraform plan -out terraform.tfplan
terraform apply terraform.tfplan
```

please note that the state is local, just to make things simpler to run.
after creating the state locally it's possible to move it to an S3 bucket, i usually do that after creating the basic S3 bucket from terraform itself so it will be managed by the code


## 2. build the service docker images
from the main directoy go into the service1 docker directory

```
cd packages/service1

```

build the docker
```
docker build ./ -t service1:1
```

## 3. push created images to ecr
```
docker tag service1:1 851725552187.dkr.ecr.eu-north-1.amazonaws.com/service1:1
docker push 851725552187.dkr.ecr.eu-north-1.amazonaws.com/service1:1
```

## 4. install the charts
```
helm upgrade --install service1 chart/vi-service1

```

in order to perform the same for service2, restart steps 2..4 replaceing each "service1" anotations with "service2"


