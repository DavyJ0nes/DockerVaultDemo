# Using Hashicorp Vault within a Docker environment

## Description
> Please Note!
> This is not an example of Vault best practices by any means and this should not be used anywhere near a production environment.

This is a demo to show how you could use a vault within a Dockerised environment. Note that vault is not being exposed outside of the Docker created network.

The Vault data is being stored within a Docker volume so the data is persistant to the Vault container instance failing. This is not HA obviouslt but demonstrates how this could be expanded on in future.

## Usage
All the useful commands for running this demo are located within the Makefile. You should not need to install any of the Go dependencies as this is being taken care of by [go dep](https://github.com/golang/dep) and the go binary is being built within Docker.

See below for how to run the demo:

```shell
# Build everything and run the environment. This will generate a secret using the go app.
make go

# This will run the app again, generating a new secret. Should only be run after `make go`
make run

# Check the logs of the app service to show that we're able to Write to and Read from the Vault
make logs

# You can stop all the containers and check the status of the environment with the following:
#  This will not destroy any of the volumes so you will be able to run make run again
make stop

# This will give you the output of `vault list secret` from the app containers perspective.
#  Is to show that secrets are persistant
make list-secrets

# If you would like a shell with the app container then you can use the following:
make login

# Remove all containers, volumes etc. for the environment
make clean-up

## Within the container you can use the following commands:

### Get Status of Vault
vault status

### Write A Secret To The Vault
vault write secret/funtimes value=always

### Read A Secret From The Vault
vault read secret/funtimes

### List the Secrets Keys in the Vault
vault list secret
```

## TODO

## Requirements
- [Docker v17.06.1](https://docs.docker.com/engine/installation/)
- [Golang v1.8](https://golang.org/doc/install)
- [Go Dep for Go Dependencies](https://github.com/golang/dep)

## License
MIT
