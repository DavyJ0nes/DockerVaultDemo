# Using Hashicorp Vault within a Docker environment

## Description
This is a demo to show how you could use a vault within a dockerised environment. Note that vault is not being exposed outside of the docker created network.

> Please Note!
> This is not an example of Vault best practices by any means and this sbould not be used anywhere near a production environment.

## Usage
All the useful commands for running this demo are located within the Makefile. See below for how to run the demo:

```
# Build everything and run the enviornment.
make run

# Check the logs of the app service to show that we're able to Write to and Read from the Vault
make logs

# Remove all containers, volumes etc for the environment
make clean-up
```

## License
MIT
