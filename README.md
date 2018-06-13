# Azure Deployment Assignment

This repository contains solution for azure deployment assigned by Sentia. Source files are divided into two groups and files related to each group are prefix accordingly.

## ARM Deployment

The first part of assignment deploys a resource group, storage account and virtual network with 3 subnets. The solution has been created with robustness, flexibility and reusability in mind.
There is a number of properties required for some resources. To fullfil those requirements the solution should be deployed with following parameters:

````
.\azuredeploy.ps1 -StagingDirectory "C:\Users\ContainerAdministrator\CloudDrive" -ResourceGroupName sentia -ResourceGroupTags @{ Environment=“Test”; Company=“Sentia” } -ResourceGroupLocation “westeurope”
````

### Assumptions
1. There will be only small number of subnets with naming conventions based on customer needs. These may need to be different per subnet thus resource iteration might not be desirable. 
2. Deployment is done in secure manner via Azure Cloud Shell (PowerShell) 

## Policy Deployment

The second part of assignment deploys a policy definition and assignment. It will restrict resource types to only allow some resource types. To fullfil those requirements the solution should be deployed with following parameters:

````
.\azurepolicy.ps1 -StagingDirectory C:\Users\ContainerAdministrator\CloudDrive -SubscriptionId “xxxx-xxxx-xxxx-xxxx-xxxx" -ResourceGroupName sentia -AllowedResourceTypes @("Microsoft.Compute/virtualMachines", "Microsoft.Network/virtualNetworks", "Microsoft.Storage/storageAccounts")
````

### Assumptions
1. There is only one policy definition to be deployed. If however we would require more than one, script could be adjusted to deploy multiple definitions or additional scripts could support this requirement.
2. There are many compute, network and storage resource types available in Azure. For the sake of simplicity of example only 3 specific types have been chosen.
3. Scope for policy is resource group within subscription as opposed to complete subscription.
4. Deployment is done in secure manner via Azure Cloud Shell (PowerShell) 