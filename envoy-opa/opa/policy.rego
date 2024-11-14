package envoy.authz

default allow = false

# Allow if the request is authenticated by mTLS (service-to-service)
allow {
    input.attributes.request.http.headers["x-forwarded-client-cert"]
}

# Allow if the request is authenticated by OAuth (user-to-service)
#   claims := payload
allow {
    required_roles[r]
}

# Extract claims from JWT token if OAuth is used
claims := payload {
    [_, payload, _] := io.jwt.decode(bearer_token)
}

bearer_token := t {
    v := input.attributes.request.http.headers.authorization
    startswith(v, "Bearer ")
    t := substring(v, count("Bearer "), -1)
}

# Required roles for paths
required_roles[r] {
    perm := role_perms[claims.roles[r]][_]
    perm.method = input.attributes.request.http.method
    perm.path = input.parsed_path
}

# Define roles and permissions
role_perms = {
    "team1": [
        {"method": "GET", "path": "/workspaces/1"},
        {"method": "GET", "path": "/workspaces/2"},
    ],
    "team2": [
        {"method": "GET", "path": "/workspaces/2"},
    ],
}
