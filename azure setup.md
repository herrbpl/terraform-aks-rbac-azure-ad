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


## TLS cert creation

```bash
openssl genrsa -out ./ca.key.pem 4096
openssl req -key ca.key.pem -new -x509 -days 7300 -sha256 -out ca.cert.pem -extensions v3_ca
openssl genrsa -out ./tiller.key.pem 4096
openssl genrsa -out ./helm.key.pem 4096
openssl req -key tiller.key.pem -new -sha256 -out tiller.csr.pem
openssl req -key helm.key.pem -new -sha256 -out helm.csr.pem
echo subjectAltName=IP:127.0.0.1 > extfile.cnf
openssl x509 -req -CA ca.cert.pem -CAkey ca.key.pem -CAcreateserial -in tiller.csr.pem -out tiller.cert.pem -days 365 -extfile extfile.cnf
openssl x509 -req -CA ca.cert.pem -CAkey ca.key.pem -CAcreateserial -in helm.csr.pem -out helm.cert.pem  -days 365

```

## helm init

```bash
helm init --dry-run --debug --tiller-tls --tiller-tls-cert ./tiller.cert.pem --tiller-tls-key ./tiller.key.pem --tiller-tls-verify --tls-ca-cert ca.cert.pem --service-account=tiller-system --tiller-namespace=kube-system --override "spec.template.spec.containers[0].command={/tiller,--storage=secret}" --node-selectors "beta.kubernetes.io/os=linux" > helm.yaml
```