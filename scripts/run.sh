#!/bin/sh

export PORT=$GATEWAY_PORT

# Check if a certificate is provided
if [[ -n "$GATEWAY_SSL_PORT" ]]
then
  echo "A certificate has been provided..."
  # Save the env in a file
  echo $GATEWAY_SSL_CERT | sed -e 's/\\n/\n/g' > /tmp/localhost.pem
  echo $GATEWAY_SSL_KEY | sed -e 's/\\n/\n/g' > /tmp/key.pem
  # Create the keystore
  openssl pkcs12 \
    -inkey /tmp/key.pem \
    -in /tmp/localhost.pem \
    -export \
    -out /keystore.p12 \
    -password pass:password
  # Define the env var for enabling SSL
  export SPRING_PROFILES_ACTIVE='ssl'
  export PORT=$GATEWAY_SSL_PORT
fi

# Start the application
java -jar /app.jar
