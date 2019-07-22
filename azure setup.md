# Configuration for Azure tenant 

## Enable AKS multiple node pools and ScaleSet functionality

https://docs.microsoft.com/en-us/azure/aks/use-multiple-node-pools

```bash
# Install the aks-preview extension
az extension add --name aks-preview

# Update the extension to make sure you have the latest version installed
az extension update --name aks-preview
```

```bash
# register features
az feature register --name MultiAgentpoolPreview --namespace Microsoft.ContainerService
az feature register --name VMSSPreview --namespace Microsoft.ContainerService
```

```bash
# Verify 
az feature list -o table --query "[?contains(name, 'Microsoft.ContainerService/MultiAgentpoolPreview')].{Name:name,State:properties.state}"
az feature list -o table --query "[?contains(name, 'Microsoft.ContainerService/VMSSPreview')].{Name:name,State:properties.state}"
```

```bash
# register provider
az provider register --namespace Microsoft.ContainerService
```

## Create required Azure apps and service principals

Check https://pixelrobots.co.uk/2019/02/create-a-rbac-azure-kubernetes-services-aks-cluster-with-azure-active-directory-using-terraform/ 

Or https://github.com/jcorioland/aks-rbac-azure-ad/tree/master/azure-ad




