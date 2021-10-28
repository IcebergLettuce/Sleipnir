## Notes

### How To:

Steps to bootstrap STEM

- Create a Key in AWS KMS  



______________________________
### Part 1: 
#### Automated provisionining of infrastructure and installation of Kubernetes

Used Technologies:
- Terraform & Bash

Alternative Technologies:
- Pulumi

Open Questions:
- Would be interesting to restrict the access to certain instances with AWS IAM control.
- Is it possible to 'destroy' the provisioned system if the cos reached a certain level.

Notes:
- It is important to create an AWS with restricted access to avoid any privilege escalation scenarios.
- The 'remote-exec' block of the terraform file is execute prior binding the elastic IP adress. This is requires that we set up networking related components in a separated step


https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&ved=2ahUKEwjYofK2hOvzAhVz9OAKHVnlBP04ChAWegQIBBAB&url=http%3A%2F%2Fevents19.linuxfoundation.org%2Fwp-content%2Fuploads%2F2017%2F12%2FHashicorp-Terraform-Deep-Dive-with-no-Fear-Victor-Turbinsky-Texuna.pdf&usg=AOvVaw3lxkN2rXjK8UI8apfYJNC-

Common mistakes: https://blog.pipetail.io/posts/2020-10-29-most-common-mistakes-terraform/
______________________________
### Part 2: 
#### Make Kubernetes accessible to the outside world


Open Questions:
- TBD
- TBD

Notes:
- TBD
- TBD