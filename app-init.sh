#/bin/sh

## app-init.sh
##   This is an initialisation script that is used to demo how to use Vault within a Docker environment.
##   It starts by initialising the server and then proceeds to unseal the Vault.
##   Once that is done then start up the demo app, which writes to and reads from the unsealed Vault.
## DavyJ0nes 2017

vault_status=$(vault status 2>/dev/null)
# shellcheck disable=SC2002
random_string=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

if [ "$vault_status" ]; then
  echo "!! Vault Server is already initialised"
  echo "# Starting App..."
  ./vault-demo-example -secret-key=oldSecret -secret-value="$random_string"
else
  printf "\n# Initialising Vault Server...\n"
  vault init > vault-keys
  printf "\n# Unsealing Vault Server...\n"
  printf "\n## Running 1st Unseal of Vault Server...\n"
  # shellcheck disable=SC2046
  vault unseal $(grep 'Key 1:' /vault-keys | awk '{print $NF}')
  printf "\n## Running 2nd Unseal of Vault Server...\n"
  # shellcheck disable=SC2046
  vault unseal $(grep 'Key 2:' /vault-keys | awk '{print $NF}')
  printf "\n## Running 3rd Unseal of Vault Server...\n"
  # shellcheck disable=SC2046
  vault unseal $(grep 'Key 3:' /vault-keys | awk '{print $NF}')
  printf "\n#############################################\n"
  grep 'Initial Root Token:' /vault-keys | awk '{print $NF}' > /root/.vault-token
  echo "# Starting App..."
  ./vault-demo-example -secret-key=newSecret -secret-value="$random_string"
fi
