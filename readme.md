## README




## ENVOY ODIC + MTLS
checkout envoy-okta-oidc envoy example:
the envoy is configured for the following
1. https endpoint enabled
2. Lua filter to check for a client certificate
3. OIDC Authenticaiton IF client certificate is unavailable, SKIP if available using pass_through_matcher
4. Authorize request by forwarding to OPA sidecar


## POLICIES
Checkout policies folder for examples of rego polices for MTLS AND OIDC
TODO: combine policies into one to run the server


### RUN-TIME POLICY CHANGES
1. FOR first-party - input-overload and have fsnotify for policy, use hashi-vault + external secret for policies
2. FOR 3rd-party - OPA server has watch mode for watching policies, use hashi-vault + external secret for policies ref: https://www.openpolicyagent.org/docs/latest/cli/
