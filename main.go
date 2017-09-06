package main

import (
	"flag"
	"fmt"
	"log"
)

func main() {
	// Setting up Some argument Flags that specify the secret key pair
	secretKeyPtr := flag.String("secret-key", "hello", "secret key")
	secretValPtr := flag.String("secret-value", "world", "secret value")
	flag.Parse()

	// Set up Vault API Client
	client, err := initVaultClient()
	if err != nil {
		log.Fatal("Error Creating API Client:", err)
	}

	// Write Secret To Vault
	err = writeSecret(client, *secretKeyPtr, *secretValPtr)
	if err != nil {
		log.Fatal("Error Writing Secret To Vault:", err)
	}

	// Read Secret From Vault
	secretString, err := readSecret(client, *secretKeyPtr)
	if err != nil {
		log.Fatal("Error Reading Secret From Vault:", err)
	}

	fmt.Println(secretString)
}
