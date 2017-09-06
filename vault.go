package main

import (
	"fmt"
	"io/ioutil"
	"strings"

	"github.com/hashicorp/vault/api"
)

// initVaultClient sets up the vault API client
func initVaultClient() (*api.Client, error) {
	conf := api.DefaultConfig()
	client, err := api.NewClient(conf)
	if err != nil {
		return client, err
	}

	// This is a bit hacky. Having to read token from filesystem
	token, err := ioutil.ReadFile("/root/.vault-token")
	if err != nil {
		return client, err
	}

	client.SetToken(strings.Trim(string(token), "\n"))

	return client, nil
}

// writeSecret writes the requested secret to Vault
func writeSecret(client *api.Client, secretKey, secretVal string) error {
	// Status Line to help with demo
	fmt.Println("### Writing Secret To Vault...")
	secretPath := fmt.Sprintf("secret/%s", secretKey)

	data := map[string]interface{}{
		"value": secretVal,
	}

	_, err := client.Logical().Write(secretPath, data)
	if err != nil {
		return err
	}
	return nil
}

// readSecret Prints the Secret Value to console
func readSecret(client *api.Client, secretKey string) (string, error) {
	// Status Line to help with demo
	fmt.Println("### Reading Secret From Vault...")

	key := fmt.Sprintf("secret/%s", secretKey)

	secret, err := client.Logical().Read(key)
	if err != nil {
		return "", nil
	}

	return fmt.Sprintf("Secret = %s", secret.Data["value"]), nil
}
