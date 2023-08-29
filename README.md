# Self hosted GitHub runners using Azure Container apps and scaling with KEDA

The following contains a simple setup for using Azure Container Apps
as self hosted runners on GitHub, and uses KEDA scaling rules for
registering more runners as needed.

The following two directories contain the necessary terraform code:

* Layer1 deploys the resource group and an Azure Container Registry
* Layer2 deploys a user assigned managed identity, RBAC for identity, container app environment and container app

Additionally, a Dockerfile with a makefile is included for registering a runner.

## Deployment order

The Dockerfile can be built and tested locally before deploying any of the Terraform layers.
You can, though, deploy the layer1, use the makefile to build and push the Dockerfile and then deploy layer2.

I am too lazy to continue working on the makefile to make it a one-click option as the PoC is working as intended.