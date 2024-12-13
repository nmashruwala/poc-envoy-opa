// run server
go run main.go

// 
docker compose up

// run the envoy application
docker run --rm -e LOG_LEVEL=trace \
--network host \
-v ~/poc-envoy-opa/certs:/var/run/autocert.step.sm \
-v ~/poc-envoy-opa/envoy-lua-okta.yaml:/etc/envoy/envoy.yaml \
-v ~/poc-envoy-opa/envoy-okta-oidc-secret.yaml:/etc/envoy/oidc-secret.yaml \
-v ~/poc-envoy-opa/hmac-secret.yaml:/etc/envoy/hmac-secret.yaml \
--name envoy-test2 harbor.wsbidev.net/stage-needham/wasabi/envoy-contrib:7.23.3184-2024-10-23-43c38a7885

// run the opa application
docker run --rm \
  -v ~/poc-envoy-opa/policy.rego:/etc/policy.rego \
  --name opa openpolicyagent/opa:latest-envoy-static \
  run --server \
  --log-level=debug \
  --log-format=json-pretty \
  --set=plugins.envoy_ext_authz_grpc.addr=:9191 \
  --set=decision_logs.console=true \
  --set=plugins.envoy_ext_authz_grpc.path=envoy/authz/allow \
  /etc/policy.rego

curl --cert ./certs/site.crt --key ./certs/site.key --cacert ./certs/root.crt -i https://localhost:13334/mtls
curl --cert ./certs/site.crt --key ./certs/site.key --cacert ./certs/root.crt -i -H "Authorization: Bearer $ALICE_TOKEN" https://localhost:13334/mtls
curl --cacert ./certs/root.crt -i https://localhost:13334/mtls

openssl x509 -in ./certs/site.crt -text
openssl x509 -in ./certs/root.crt -text


Subject: CN = rabbitmq.rabbitmq.svc.cluster.local
X509v3 Subject Alternative Name: 
                DNS:rabbitmq.rabbitmq.svc.cluster.local, DNS:general.alphafr.betafr, DNS:*.rabbitmq.pod.cluster.local, DNS:rabbitmq-*, DNS:localhost



kubectl create configmap authz-policy --from-file=policy.rego --dry-run=client -o yaml | kubectl replace -f -
kubectl create configmap proxy-config --from-file=envoy.yaml --dry-run=client -o yaml | kubectl replace -f -
kubectl get configmap authz-policy -o yaml
kubectl rollout restart deployment example-app
kubectl rollout restart deployment bundle-server
kubectl delete deployment bundle-server


curl -i http://example-app/people
curl -i -d '{"firstname":"Foo", "lastname":"Bar"}' -H "Content-Type: application/json" \
  -X POST http://example-app/people


curl --cert ./certs/site.crt --key ./certs/site.key --cacert ./certs/root.crt -i http://example-app/people


kubectl create configmap certs-config \
  --from-file=/home/users/nmashruwala/poc-envoy-opa/certs/root.crt \
  --from-file=/home/users/nmashruwala/poc-envoy-opa/certs/site.crt \
  --from-file=/home/users/nmashruwala/poc-envoy-opa/certs/site.key

kubectl create configmap certs-config --from-file=/home/users/nmashruwala/poc-envoy-opa/certs/site.crt --dry-run=client -o yaml | kubectl replace -f -


kubectl run curl --restart=Never -it --rm --image curlimages/curl:8.1.2 -- sh


kubectl run curl-pod --rm -i --tty \
  --image=curlimages/curl:latest \
  --dry-run=client -o yaml > curl-pod.yaml


kubectl run curl4 \
  --restart=Never -it --rm \
  --image=curlimages/curl:8.1.2 \
  --mount type=configMap, configMapName=certs-config, target=/etc/certs \
  -- sh

kubectl run curl3 \
  --restart=Never -it --rm \
  --overrides='{
    "apiVersion": "v1",
    "spec": {
      "containers": [{
        "name": "curl",
        "image": "curlimages/curl:8.1.2",
        "command": ["sh"],
        "volumeMounts": [{
          "name": "certs-volume",
          "mountPath": "/etc/certs"
        }]
      }],
      "volumes": [{
        "name": "certs-volume",
        "configMap": {
          "name": "certs-config"
        }
      }]
    }
  }' -- sh



kubectl exec demo -c demo -- curl --cert /etc/ssl/certs/site.crt -i http://example-app/people



--cert ./certs/site.crt --key ./certs/site.key --cacert ./certs/root.crt


curl --cert /etc/certs/site.crt --key /etc/certs/site.key --cacert /etc/certs/root.crt -i http://example-app/people
