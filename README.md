# ILoveTencentCloud




https://mirrors.tuna.tsinghua.edu.cn/help/kubernetes/


```

from kubernetes import client, config

config.load_kube_config()

v1=client.CoreV1Api()
print("Listing pods with their IPs:")
ret = v1.list_pod_for_all_namespaces(watch=False)
for i in ret.items:
    print("%s\t%s\t%s" % (i.status.pod_ip, i.metadata.namespace, i.metadata.name))

```

```
#!/usr/bin/env bash

APISERVER=$(cat /root/.kube/config|grep server|awk '{print $2}')

TOKEN=$(cat /root/.kube/config |grep token|awk  '{print $2}')

# GET /api/v1/namespaces/{namespace}/secrets
namespace=beijing-release
curl -X GET ${APISERVER}api/v1/namespaces/${namespace}/secrets --header "Authorization: Bearer $TOKEN" --insecure |jq .items[].metadata.name

```
