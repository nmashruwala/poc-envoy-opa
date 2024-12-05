# policy.rego
package envoy.authz

import rego.v1

import input.attributes.request.http as http_request

default allow := true

allow if {
	input.attributes.request.http.method == "GET"
	input.attributes.request.http.path == "/mtls"
}