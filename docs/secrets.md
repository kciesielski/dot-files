# Secrets management with rage

Encrypt a secret.

```console
echo "my-secret" | rage -R ~/.ssh/id_rsa.pub > secrets/my-secret.age
```

Decrypt it.

```console
rage -d -i ~/.ssh/id_rsa secrets/my-secret.age
```
