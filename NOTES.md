# RH Summit demo (eXate + RedHat)
This document describes how works and how to deploy the demo for the RH Summit
2025 in collaboration with eXate


## Architecture
TODO Diagram

## Logging
```sh
ssh -i ./skupper-node-a_key.pem azureuser@172.187.147.100
```

## Custom Frontend for eXate
### Building modified frontend image
```sh
podman build -t quay.io/avillega/patient-portal-frontend:latest -f frontend/Containerfile frontend/
podman push quay.io/avillega/patient-portal-frontend:latest
```
```sh
# All in one command
podman build -t quay.io/avillega/patient-portal-frontend:latest -f frontend/Containerfile frontend/ ; podman push quay.io/avillega/patient-portal-frontend:latest ; oc scale deployment/frontend-exate --replicas=0; oc scale deployment/frontend-exate --replicas=1
```
```sh
# Test GetToken
curl --insecure https://frontend-exate-skupper-patient-portal-public.apps.exate-alpha.azure.sandboxedcontainers.com/apigator/gettoken
```
```sh
# Test Protect
curl --insecure -XPOST --data @./frontend/body.json https://frontend-exate-skupper-patient-portal-public.apps.exate-alpha.azure.sandboxedcontainers.com/apigator/protect | jq '.result | fromjson'
```

### Deploying
```sh
oc new-project skupper-exate-patient-portal
oc apply -f frontend/kubernetes.yaml
```

## Custom router for eXate
### Building modified frontend image
```sh
podman build -t quay.io/avillega/patient-portal-hub:latest -f hub/Containerfile hub/
podman push quay.io/avillega/patient-portal-hub:latest
```


## Skupper network setup
### Installation
#### 1. Init

**PUBLIC:**
```sh
export PS1="$PS1 - PUBLIC: "
export KUBECONFIG=./kubeconfig-public
oc project skupper-patient-portal-public
```

**PRIVATE-GB:**
```sh
export PS1="$PS1 - PRIVATE-GB: "
export KUBECONFIG=./kubeconfig-private-gb
oc project skupper-patient-portal-private-gb
```

**PRIVATE-CH:**
```sh
export PS1="$PS1 - PRIVATE-CH: "
export KUBECONFIG=./kubeconfig-private-ch
oc project skupper-patient-portal-private-ch
```

**HUB:**
```sh
export PS1="$PS1 - HUB: "
export KUBECONFIG=./kubeconfig-hub
oc project skupper-patient-portal-hub
```

**DATABASE-VM:**
```sh
export PS1="$PS1 - DB: "
export SKUPPER_PLATFORM=podman
podman network create skupper
systemctl --user enable --now podman.socket
```

#### 2. Deploy Apps

**PUBLIC:**
```sh
oc apply -f frontend/kubernetes.yaml
```

**PRIVATE-GB:**
```sh
oc apply -f payment-processor/kubernetes.yaml
```

**PRIVATE-CH:**
```sh
oc apply -f payment-processor/kubernetes.yaml
```

**HUB:**
```sh
oc apply -f hub/kubernetes.yaml
```

**DATABASE-VM:**
```sh
podman run --name database-target --network skupper --detach --rm -p 5432:5432 quay.io/skupper/patient-portal-database
```

#### 3. Initialize Skupper

**PUBLIC:**
```sh
skupper init --enable-console --enable-flow-collector
# Print Skupper console password
oc get secret skupper-console-users -n skupper-patient-portal-public -o jsonpath="{.data.admin}" | base64 -d | xargs echo

```

**PRIVATE-GB:**
```sh
skupper init --ingress none
```

**PRIVATE-CH:**
```sh
skupper init --ingress none
```

**HUB:**
```sh
skupper init --ingress none
```

**DATABASE-VM:**
```sh
skupper init --ingress none
```

#### 4. Link Skupper sites

**PUBLIC:**
```sh
skupper token create --uses 2 ~/secret-public.token
scp -i ./skupper-node-a_key.pem ~/secret-public.token azureuser@172.187.147.100:/home/azureuser/secret-public.token
```

**HUB:**
```sh
skupper link create ~/secret-public.token
skupper token create --uses 2 ~/secret-hub.token
```

**PRIVATE-GB:**
```sh
skupper link create ~/secret-hub.token
```

**PRIVATE-CH:**
```sh
skupper link create ~/secret-hub.token
```

**DATABASE-VM:**
```sh
skupper link create ~/secret-public.token
```

#### 5. Expose application services
**PRIVATE-GB:**
```sh
skupper expose deployment/payment-processor --port 8080 --address payment-processor-gb
```

**PRIVATE-CH:**
```sh
skupper expose deployment/payment-processor --port 8080 --address payment-processor-ch
```

**DATABASE-VM:**
```sh
skupper service create database 5432
skupper service bind database host database-target --target-port 5432
```

**PUBLIC:**
```sh
skupper service create database 5432
```

**HUB:**
```sh
skupper expose deployment/hub-exate --port 8000 --address hub
```
