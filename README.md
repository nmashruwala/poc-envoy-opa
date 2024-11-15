# Envoy OPA POC

## Certs

CA
openssl genpkey -algorithm RSA -out ca-key.pem -pkeyopt rsa_keygen_bits:2048
openssl req -x509 -new -nodes -key ca-key.pem -sha256 -days 365 -out ca-cert.pem -subj "/C=US/ST=CA/L=San Francisco/O=MyOrg/CN=MyOrg CA"

Server
openssl genpkey -algorithm RSA -out server-key.pem -pkeyopt rsa_keygen_bits:2048
openssl req -new -key server-key.pem -out server.csr -subj "/C=US/ST=CA/L=San Francisco/O=MyOrg/CN=localhost"
openssl x509 -req -in server.csr -CA ca-cert.pem -CAkey ca-key.pem -CAcreateserial -out server-cert.pem -days 365 -sha256

Client
openssl genpkey -algorithm RSA -out client-key.pem -pkeyopt rsa_keygen_bits:2048
openssl req -new -key client-key.pem -out client.csr -subj "/C=US/ST=CA/L=San Francisco/O=MyOrg/CN=client"
openssl x509 -req -in client.csr -CA ca-cert.pem -CAkey ca-key.pem -CAcreateserial -out client-cert.pem -days 365 -sha256

## Testing

curl http://localhost:5200/common -H "Authorization: Bearer $MY_JWT"
curl http://localhost:5200/workspaces/1 -H "Authorization: Bearer $MY_JWT"
curl http://localhost:5200/workspaces/3 -H "Authorization: Bearer $MY_JWT"
curl --cert ./certs/client-cert.pem --key ./certs/client-key.pem --cacert ./certs/ca-cert.pem https://localhost:5200/common
curl --cacert ./certs/ca-cert.pem https://localhost:5200/common
