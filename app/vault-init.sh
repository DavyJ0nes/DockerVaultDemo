#/bin/sh

## vault-init.sh
##   This is an initialisation script that is used to demo how to use Vault within a Docker environment.
##   It starts by initialising the server and then proceeds to unseal the Vault.
##   Once that is done then start up the demo app, which writes to and reads from the unsealed Vault.

## DavyJ0nes 2017

##---------- DEFINING FUNCTIONS ----------##

# initVaultServer Initialises the Vault Server
initVaultServer() {
  printf "\\n# Initialising Vault Server...\\n"
  vault init > /root/vault-keys
}

# unsealVaultServer unseals the Vault Server
unsealVaultServer() {
  printf "\\n# Unsealing Vault Server...\\n"
  printf "\\n## Running 1st Unseal of Vault Server...\\n"
  # shellcheck disable=SC2046
  vault unseal "$(grep 'Key 1:' /root/vault-keys | awk '{print $NF}')"
  printf "\\n## Running 2nd Unseal of Vault Server...\\n"
  # shellcheck disable=SC2046
  vault unseal "$(grep 'Key 2:' /root/vault-keys | awk '{print $NF}')"
  printf "\\n## Running 3rd Unseal of Vault Server...\\n"
  # shellcheck disable=SC2046
  vault unseal "$(grep 'Key 3:' /root/vault-keys | awk '{print $NF}')"
  grep 'Initial Root Token:' /root/vault-keys | awk '{print $NF}' > /root/.vault-token
  printf "\\n#############################################\\n"
}

##---------- SETUP ----------##

vault_status=$(vault status 2>/dev/null)
# shellcheck disable=SC2002
random_secret=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
# shellcheck disable=SC2002
random_key=$(cat /dev/urandom | tr -dc '[:upper:]' | fold -w 16 | head -n 1)

##---------- CHECK STATUS OF VAULT ----------##

if [ "$vault_status" ]; then
  echo "!! Vault Server is already initialised"
  if [ "$(vault status | grep 'Sealed:' | awk '{print $NF}')" = "true" ]; then
    echo "!! Vault Server is Sealed"
    unsealVaultServer
  fi
else
  initVaultServer
  unsealVaultServer
fi

##---------- START APP ----------##

echo "# Starting App..."
./vault-demo-example -secret-key="$random_key" -secret-value="$random_secret"
printf "\\n#############################################\\n"

