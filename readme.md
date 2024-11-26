// run server
go run main.go

// run the envoy application
docker run --rm -e LOG_LEVEL=trace \
--network host \
-v ~/poc-envoy-opa/certs:/var/run/autocert.step.sm \
-v ~/poc-envoy-opa/envoy-lua-okta.yaml:/etc/envoy/envoy.yaml \
-v ~/poc-envoy-opa/envoy-okta-oidc-secret.yaml:/etc/envoy/oidc-secret.yaml \
-v ~/poc-envoy-opa/hmac-secret.yaml:/etc/envoy/hmac-secret.yaml \
--name envoy-test2 harbor.wsbidev.net/stage-needham/wasabi/envoy-contrib:7.23.3184-2024-10-23-43c38a7885


curl --cert ./certs/site.crt --key ./certs/site.key --cacert ./certs/root.crt -i https://localhost:13334/mtls