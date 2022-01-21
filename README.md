## About the Workbench project
<br>
This repository is what the name says - It is a workbench.
<br>
<br>

**Recently when I was on vacation, I received an email from AWS. 
Not again, a budget alert! <br> I forgot to deprovision the cloud environment I used to tinker around. Such an unfortunate surprise won't happen again.**

This project offers three GitHub Action Pipelines to avoid this:


- Simple Kubernetes Custer
- Secure Kubernetes Cluster
- Destroy Kubernetes Cluster

*(even it says 'secure', these pipelines create an environment to tinker around. So far away from production! Don't even think about it. During the execution of the action, the system is very vulnerable)*
<br>
<br>
What is going to happen:
<br>
<br>

1. Terraform is used to provision an EC2 instance on AWS and bind an elastic IP address to it. Either the DNS records are already configured, or you have to do that manually at your domain registrar. Theoretically, one can also modify the terraform file to do that for you... But this can be a little bit annoying as it takes some time until they are available.

2. Docker and Kubeadm are being installed. We use Kubeadm to create a single-node Kubernetes cluster. 


3. Deployment of Traefik as an Ingress Controller. We expose two NodePorts, one for HTTP and one for HTTPS traffic.


4. Deployment of ArgoCD and RabbitMQ.


5. Deployment of Kubernetes and Traefik Dashboard.


6. An NGINX Reverse Proxy is installed on the host machine and uses Let's Encrypt to acquire TLS certificates.


7. In the "Secure" pipeline, we also add an OAuth2 proxy that hooks into the NGINX Reverse Proxy. 


**Jipiii, after ~7 minutes, there is a fun environment ready to play.**

![Alt text](doc/pipeline.png?raw=true "Title")
