#/bin/sh

vault_status=$(vault status 2>/dev/null)

if [ "$vault_status" ]; then
  echo "Vault is initialised"
  echo "Starting App..."
  ./vault-demo-example
else
  printf "\n# Initialising Vault Server...\n"
  vault init > keys.txt
  printf "\n# Running 1st Unseal of Vault Server...\n"
  vault unseal $(grep 'Key 1:' /keys.txt | awk '{print $NF}')
  printf "\n# Running 2nd Unseal of Vault Server...\n"
  vault unseal $(grep 'Key 2:' /keys.txt | awk '{print $NF}')
  printf "\n# Running 3rd Unseal of Vault Server...\n"
  vault unseal $(grep 'Key 3:' /keys.txt | awk '{print $NF}')
  printf "\n#############################################\n"
  grep 'Initial Root Token:' /keys.txt | awk '{print $NF}' > /root/.vault-token
  echo "# Starting App..."
  ./vault-demo-example
fi
