package envoy.authz

import rego.v1

default allow := false

# Allow rule
allow if is_cn_valid

# Check if the Common Name (CN) is valid
is_cn_valid if {
    cert_header := input.attributes.request.http.headers["x-forwarded-client-cert"]
    parts := split(cert_header, ";") # Split cert attributes
    some part in parts
    regex.match(`Subject=.{0,3}CN=(rabbitmq.rabbitmq.svc.cluster.local)`, part)
}

# Extract the Common Name (CN) from the client certificate
cn := input.client_certificates[0].Subject.CommonName

allow if cn == "rabbitmq.rabbitmq.svc.cluster.local"