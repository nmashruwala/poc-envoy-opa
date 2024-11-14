package envoy.authz

# Importing required modules
import input.attributes.request.http as http_request
import input.parsed_path

# Default deny policy
default allow = false

# Rule to allow GET requests to path starting with "health"
allow {
    parsed_path[0] == "health"
    http_request.method == "GET"
}

# Rule to allow GET requests to path starting with "common"
allow {
    parsed_path[0] == "common"
    http_request.method == "GET"
}

# Rule to check required roles for accessing resource
allow {
    required_roles[r]
}

# Rule to define required roles for accessing resource
required_roles[r] {
    perm := role_perms[claims.roles[r]][_]
    perm.method = http_request.method
    perm.path = http_request.path
}

# Decoding JWT bearer token and extracting claims
claims := payload {
    [_, payload, _] := io.jwt.decode(bearer_token)
}

# Extracting JWT bearer token from authorization header
bearer_token := t {
    v := http_request.headers.authorization
    startswith(v, "Bearer ")
    t := substring(v, count("Bearer "), -1)
}

# Mapping of roles to permissions
role_perms = {
    "team1": [
        {"method": "GET",  "path": "/workspaces/1"},
        {"method": "GET",  "path": "/workspaces/2"},
    ],
    "team2": [
        {"method": "GET",  "path": "/workspaces/2"},
    ],
}
