## To get info about the user who is using the aws cli we can use the following command
aws sts get-caller-identity
### To create cluster without node group
eksctl create cluster --name "shahin-cluster" --region "ap-south-2" --version "1.30" --with-oidc --without-nodegroup
### To create a nodegroup 
eksctl create nodegroup `
--cluster "shahin-cluster" `
--name "workernodegroup" `
--region "ap-south-2" `
--ssh-public-key "my_idrsa" `
--node-type "t3.micro" `
--nodes 1 `
--nodes-min 1 `
--nodes-max 2 `
--node-volume-size 15

### To get credentials 
aws eks update-kubeconfig --region "ap-south-2" --name "shahin-cluster"

### To delete nodegroup 
eksctl delete nodegroup --cluster "shahin-cluster" --name "workernodegroup" --region "ap-south-2"

### To delete cluster
eksctl delete cluster --name "shahin-cluster" --region "ap-south-2"


### Alternatively we can delete by deleting cloudformation stack
