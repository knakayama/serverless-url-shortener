serverless-url-shortener
========================

## Original concept

https://aws.amazon.com/jp/blogs/compute/build-a-serverless-private-url-shortener/

## How to use

```bash
$ curl \
  -fsSL 'https://s3-us-west-2.amazonaws.com/sha-public-us-west-2/URLShortener/index.html' \
  -o infrastructure/modules/s3/sources/admin/index.html
$ apex infra apply \
  -target=module.iam \
  -var apex_function_serverless_url_shortener=aaa
$ apex deploy serverless_url_shortener
$ apex infra plan \
  -var-file=secret.tfvars
```
