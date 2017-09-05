#/bin/sh

vault_status=$(vault status)

if [ "$vault_status" ]; then
  echo "Vault is initialised"
  echo "Starting App..."
  ./vault-demo-example
else
  vault init > keys.txt
  vault unseal $(grep 'Key 1:' /keys.txt | awk '{print $NF}')
  vault unseal $(grep 'Key 2:' /keys.txt | awk '{print $NF}')
  vault unseal $(grep 'Key 3:' /keys.txt | awk '{print $NF}')
  echo "#############################################"
  grep 'Initial Root Token:' /keys.txt | awk '{print $NF}' > /root/.vault-token
  echo "Starting App..."
  ./vault-demo-example
fi
