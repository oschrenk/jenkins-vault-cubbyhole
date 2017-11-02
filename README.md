# Cubbyhole

Initiates a cubbyhole procedure

*Run locally*

```
docker build -t cubbyhole .
docker run -e VAULT_TOKEN=123 -e VAULT_ADDR=http://127.0.0.1:8200 cubbyhole

# access localhost vault
docker run --network host -e VAULT_TOKEN=123 -e VAULT_ADDR=
http://127.0.0.1:8200 oschrenk/cubbyhole
```

*Run from registry*

```
docker run -e VAULT_TOKEN=123 -e VAULT_ADDR=http://127.0.0.1:8200 oschrenk/cubbyhole
```

## Publishing

```
docker build -t oschrenk/cubbyhole
docker push oschrenk/cubbyhole
```



## Resources

https://github.com/rickfast/vault-cubbyhole-auth-model-example

