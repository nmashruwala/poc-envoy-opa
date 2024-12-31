# policy.rego
package envoy.authz

import rego.v1

import input.attributes.request.http as http_request

default allow := false

allow if {

	print("Input is:", input)
	print("input cert",crypto.x509.parse_certificates(urlquery.decode(input.attributes.source.certificate)))
	input.attributes.request.http.method == "GET"
	input.attributes.request.http.path == "/mtls"
}