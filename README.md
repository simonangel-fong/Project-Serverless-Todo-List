# Terraform_AWS_API_Lambda_S3_CSV
A repo of Terraform Project implement AWS API Gateway, Lambda, S3.

```sh
# should be the python dir, according to the document.
# python/              # Required top-level directory
# └── requests/
# └── boto3/
# └── numpy/
# └── (dependencies of the other packages)
pip install -r ./requirements.txt --platform manylinux2014_x86_64 --only-binary=:all: -t ./python --upgrade
# power shell
Compress-Archive -Path ./python -DestinationPath ./layer.zip -Force
```