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