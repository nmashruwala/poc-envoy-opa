# THIS POLICY IS AN EXAMPLE FOR CN OR SAN MATCH OF CLIENT CERTIFICATE
# policy.rego
package envoy.authz

import rego.v1

# import input.attributes.request.http as http_request

default allow := false

allow if {
	print("Input is:", input)
	token := get_id_token(input)
	print("IdToken:", token)
	print("decoded_id_token", io.jwt.decode(token))
}

get_id_token(input_data) := id_token if {
	cookies := split(input_data.attributes.request.http.headers.cookie, "; ")
	some cookie in cookies
	print("cookie is:", cookie)
	startswith(cookie, "IdToken=")
	id_token := trim_prefix(cookie, "IdToken=")
}
