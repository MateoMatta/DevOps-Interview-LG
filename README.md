# DevOps-Interview-LG
This repository serves as answer of the challenge proposed on the interview.

It has been created a basic web site that serves of example to be deployed, to implement and show the use of Hashicorp Terraform as Infrastructure as a Code tool. All of this deployed on AWS.
The solution has was configured with a new VPC, Subnet, Internet gateway, Route table, Security Group, LB, Autoscaling Group of just 1 instance, and its proper personalized Launch configuration with a bash script that configures the server.

### Prerequisites
*Terraform, Git, (particularly to perform 2nd step of environmental variables) Linux machine, .pem key pair ("candidate.pem" as it was configured on TF template)*

### Implementation
1. Download the GitHub project:

```git clone https://github.com/MateoMatta/DevOps-Interview-LG.git```
  
```cd DevOps-Interview-LG```
  
2. Add the AWS Access Keys (Particular way): go to your Linux console, and create environment variables with the AWS Access Key and AWS Access Secret Key:

```export AWS_ACCESS_KEY_ID="{ReplaceHere_AccessKey}"```
  
```export AWS_SECRET_ACCESS_KEY="{ReplaceHere_SecretAccessKey}"```
  
3. Initizalize and deploy the infrastructure:

```terraform init```
  
```terraform plan```
  
```terraform apply -auto-approve```
  
4. Once the process is completed, the console will show the output of the LoadBalancer's DNS. A link you can copy and paste on your browser, to see the website working on a few minutes.
  It should be shown a basic web with "Mateo Matta interview demo!" as title and a little description. 

- Extra: to double-check if you're ready to watch the page working, go to EC2 Dashboard (https://us-east-1.console.aws.amazon.com/ec2/home?region=us-east-1#Instances:instanceState=running;sort=instanceState), and check if the *Instance state* of **demo-asg-instance-1** is "Running" on **us-east-1** region.

### Citation
All the code rights to the developers mentioned below.

    @development{Demo,
        author    = Mateo Matta}, 
        title     = {DevOps interview demo}
    }
