import jwt
import datetime
import base64

# Secret key for signing tokens (use a secure, random value in production)
SECRET_KEY = "mysecret"

# Base64 encode the secret key
encoded_secret_key = base64.b64encode(SECRET_KEY.encode()).decode()

# Print the Base64 encoded secret key
print("Base64 Encoded Secret Key:", encoded_secret_key)


def generate_token(team):
    # Define payload based on team roles
    # claims = {
    #     "roles": [team],
    #     "exp": datetime.datetime.utcnow() + datetime.timedelta(hours=1)  # Token expiration time
    # }
    claims = {
        "iss": "self",  # Match with 'issuer' in Envoy config
        "aud": "wasabiuser",
        "exp": datetime.datetime.utcnow() + datetime.timedelta(hours=1),
        "roles": [team]
    }
    # Generate and return JWT token
    token = jwt.encode(claims, SECRET_KEY, algorithm="HS256")
    return token

# Generate tokens for team1 and team2
team1_token = generate_token("team1")
team2_token = generate_token("team2")

print(f"JWT Token for team1: {team1_token}")
print(f"JWT Token for team2: {team2_token}")
