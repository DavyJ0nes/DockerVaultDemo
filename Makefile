all: go

app = vault-demo-example
service ?= app

binary:
	$(call blue, "# Building Golang Binary...")
	docker run --rm -it -v "$(CURDIR)":/go/src/app -w /go/src/app golang:1.8 sh -c 'go get && CGO_ENABLED=0 go build -a --installsuffix cgo --ldflags="-s" -o ${app}'

build: binary
	$(call blue, "# Building Docker Images From Docker-Compose...")
	docker-compose build
	$(MAKE) clean

login: build
	$(call blue, "# Running Shell within App...")
	docker-compose run app sh

stop:
	$(call blue, "# Stopping and Killing Containers...")
	docker-compose kill

list-secrets:
	$(call blue, "# Listing Secret Keys in Vault...")
	docker-compose run app sh -c "vault list secret"

go: build
	$(call blue, "# Starting Stack...")
	docker-compose up -d

run:
	$(call blue, "# Running App...")
	docker-compose run app

logs:
	$(call blue, "# Outputting Logs...")
	docker-compose logs ${service}

clean-up:
	$(call blue, "# Cleaning Up Environment...")
	docker-compose kill && docker-compose rm -f -v
	docker volume rm vaultdemo_apphome
	docker volume rm vaultdemo_vault-volume


clean:
	@rm -f ${app}

define blue
  @tput setaf 4
	@echo $1
	@tput sgr0
endef
