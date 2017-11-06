# Cubbyhole

Initiates a cubbyhole procedure on Jenkins and injects the temporary token into the service definition.

*Run as build action*

Configure the `$VAULT_TOKEN` to be read from Jenkins Credentials and injected as a secret.

```
# force pull of image
docker pull oschrenk/cubbyhole
docker run -v "${WORKSPACE}":/work -e VAULT_TOKEN=$VAULT_TOKEN -e VAULT_ADDR="http://vault.marathon.mesos:8200/" -e INPUT_PATH="/work/service.json" -e OUTPUT_PATH="/work/service-tokenized.json" oschrenk/cubbyhole
cat "${WORKSPACE}/service-tokenized.json"
```

## Publishing

```
docker build -t oschrenk/cubbyhole
docker push oschrenk/cubbyhole
```

## Development

*Run locally*

```
docker build -t cubbyhole .
docker run -e VAULT_TOKEN=123 -e VAULT_ADDR=http://127.0.0.1:8200 cubbyhole

# access localhost vault
docker run --network host -e VAULT_TOKEN=123 -e VAULT_ADDR=
http://127.0.0.1:8200 oschrenk/cubbyhole
```


## Resources

https://github.com/rickfast/vault-cubbyhole-auth-model-example

