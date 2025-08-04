## Build llm image and Run the container
```sh
export QUAY_USER=${your_quay_user_id}
export IMAGE_TAG=${your_image_tag}

sh podmanrun.sh 
```
## Visit Mistral-api via container in local
```sh
$  curl -k  -X 'POST'   'http://127.0.0.1:8080/generate'   -H 'accept: application/json'   -H 'Content-Type: application/json'   -d '{
  "prompt": "What is the capital of France?",
  "max_tokens": 128,
  "temperature": 0.7
}'
{"response":"\nParis"}
```
## Install LeaderWorkerSet to deploy mistral-7b model
```sh
$oc create -f  lws-example.yaml

$ oc get pods
NAME                         READY   STATUS    RESTARTS   AGE
leaderworkerset-sample-0     1/1     Running   0          20m
leaderworkerset-sample-0-1   1/1     Running   0          20m
```

## Visit Mistral-api via leader pod
```sh
$ oc port-forward leaderworkerset-sample-0 8080:8080
Forwarding from 127.0.0.1:8080 -> 8080
Forwarding from [::1]:8080 -> 8080
Handling connection for 8080
Handling connection for 8080
Handling connection for 8080

$ curl http://localhost:8080/health
{"status":"ready","model":"Mistral-7B"}

$ curl -X POST http://localhost:8080/generate \
     -H "Content-Type: application/json" \
     -d '{"prompt":"What is the capital of France?"}'

{"response":"\nA: Paris"}
```

