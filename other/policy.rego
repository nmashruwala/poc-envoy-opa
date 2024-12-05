# policy.rego
package envoy.authz

import rego.v1

import input.attributes.request.http as http_request

default allow := false

# Allow if the CN matches a specific value
allow {
    input.request.headers["x-forwarded-client-cert"]
    cn := parse_cert_cn(input.request.headers["x-forwarded-client-cert"])
    valid_cn(cn)
}

# Extract the CN from the certificate header
parse_cert_cn(cert_header) = cn {
    split(cert_header, ";", parts)    # Split cert attributes
    some i
    parts[i] == regex("Subject=.*CN=([^,]+)", parts[i], matches) # Extract CN
    cn := matches[1]
}

# Validate the extracted CN against allowed values
valid_cn(cn) {
    cn == "rabbitmq.rabbitmq.svc.cluster.local"
}