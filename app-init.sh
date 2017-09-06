#/bin/sh

vault_status=$(vault status 2>/dev/null)
# shellcheck disable=SC2002
random_string=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

if [ "$vault_status" ]; then
  echo "Vault is initialised"
  echo "Starting App..."
  ./vault-demo-example -secret-key=oldSecret -secret-value="$random_string"
else
  printf "\n# Initialising Vault Server...\n"
  vault init > keys.txt
  printf "\n# Running 1st Unseal of Vault Server...\n"
  # shellcheck disable=SC2046
  vault unseal $(grep 'Key 1:' /keys.txt | awk '{print $NF}')
  printf "\n# Running 2nd Unseal of Vault Server...\n"
  # shellcheck disable=SC2046
  vault unseal $(grep 'Key 2:' /keys.txt | awk '{print $NF}')
  printf "\n# Running 3rd Unseal of Vault Server...\n"
  # shellcheck disable=SC2046
  vault unseal $(grep 'Key 3:' /keys.txt | awk '{print $NF}')
  printf "\n#############################################\n"
  grep 'Initial Root Token:' /keys.txt | awk '{print $NF}' > /root/.vault-token
  echo "# Starting App..."
  ./vault-demo-example -secret-key=newSecret -secret-value="$random_string"
fi
