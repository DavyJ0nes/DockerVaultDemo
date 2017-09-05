package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"os/exec"
	"strings"

	"github.com/hashicorp/vault/api"
)

func main() {
	writeSecret()
	readSecret()
}

func writeSecret() {
	fmt.Println("### Writing Secret...")
	cmd := exec.Command("vault", "write", "secret/hello", "value=world")
	err := cmd.Run()
	if err != nil {
		log.Fatal("Error with Running Write Command", err)
	}
}

func readSecret() {
	fmt.Println("### Reading Secret...")
	conf := api.DefaultConfig()
	client, err := api.NewClient(conf)

	if err != nil {
		log.Fatal("Error with Creating Vault Client", err)
	}

	token, err := ioutil.ReadFile("/root/.vault-token")

	if err != nil {
		log.Fatal("Error Reading Vault Token", err)
	}

	client.SetToken(strings.Trim(string(token), "\n"))
	secret, err := client.Logical().Read("secret/hello")

	if err != nil {
		log.Fatal("Error with Creating Vault Client", err)
	}

	fmt.Printf("Secret = %s\n", secret.Data["value"])
}
