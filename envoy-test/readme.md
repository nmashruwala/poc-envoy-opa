
// run server
go run main.go

// run the envoy application
docker run --rm -e LOG_LEVEL=trace -v /home/users/mmirza/envoy-test/certs:/var/run/autocert.step.sm --network host -v /home/users/mmirza/envoy-test/envoy-lua-okta.yaml:/etc/envoy/envoy.yaml -v /home/users/mmirza/envoy-test/envoy-okta-oidc-secret.yaml:/etc/envoy/oidc-secret.yaml -v /home/users/mmirza/envoy-test/hmac-secret.yaml:/etc/envoy/hmac-secret.yaml  --name envoy-test  wasabi/envoy-contrib:7.23.3184-2024-10-23-43c38a7885
