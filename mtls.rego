# policy.rego
package envoy.authz

import rego.v1

import input.attributes.request.http as http_request

default allow := false

cert_data := crypto.x509.parse_certificates(urlquery.decode(input.attributes.source.certificate))[0]

is_mtls_path if {
	input.attributes.request.http.method == "GET"
	input.attributes.request.http.path == "/mtls"
}

is_expected_service if {
	some dns_name in cert_data.DNSNames
	dns_name == "localhost"
}

is_expected_service if {
	cert_data.Subject.CommonName == "client"
}

# is_expected_service {
#     dns_match or common_name_match

# }

allow if {
	print("Input is:", input)
	print("cert_data", cert_data)
	is_mtls_path
	is_expected_service
}
