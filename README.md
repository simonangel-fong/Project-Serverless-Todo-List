# Terraform_AWS_API_Lambda_S3_CSV
A repo of Terraform Project implement AWS API Gateway, Lambda, S3.

```sh
# the following is what should be the python dir, according to the document.
# python/              # Required top-level directory
# └── requests/
# └── boto3/
# └── numpy/
# └── (dependencies of the other packages)

# package dependencies, pwd is terraform/
pip install -r ../lambda/requirements.txt --platform manylinux2014_x86_64 --only-binary=:all: -t ../lambda/python --upgrade

# power shell: zip file
Compress-Archive -Path ../lambda/python -DestinationPath ../lambda/layer.zip -Force
```