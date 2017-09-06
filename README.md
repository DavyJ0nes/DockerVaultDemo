# Using Hashicorp Vault within a Docker environment

## Description
This is a demo to show how you could use a vault within a dockerised environment. Note that vault is not being exposed outside of the docker created network.

> Please Note!
> This is not an example of Vault best practices by any means and this should not be used anywhere near a production environment.

## Usage
All the useful commands for running this demo are located within the Makefile. See below for how to run the demo:

```shell
# Build everything and run the environment.
make run

# Check the logs of the app service to show that we're able to Write to and Read from the Vault
make logs

# Remove all containers, volumes etc. for the environment
make clean-up

# If you would like a shell with the app container then you can use the following:
make login

## Within the container you can use the following commands:

### Get Status of Vault
vault status

### Write A Secret To The Vault
vault write secret/funtimes value=always

### Read A Secret From The Vault
vault read secret/funtimes
```

## Requirements
- [Docker v17.06.1](https://docs.docker.com/engine/installation/)
- [Golang v1.8](https://golang.org/doc/install)
- [Go Dep for Go Dependencies](https://github.com/golang/dep)

## License
MIT
