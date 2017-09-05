all: run

app = vault-demo-example
version ?= latest
service ?= app
local_port = 8080 

binary:
	$(call blue, "# Building Golang Binary...")
	docker run --rm -it -v "${GOPATH}":/gopath -v "$(CURDIR)":/app -e "GOPATH=/gopath" -w /app golang:1.8 sh -c 'CGO_ENABLED=0 go build -a --installsuffix cgo --ldflags="-s" -o ${app}'

build: binary
	$(call blue, "# Building Docker Images From Docker-Compose...")
	docker-compose build
	$(MAKE) clean

login: build
	$(call blue, "# Running Shell within App...")
	docker-compose run app sh

run: build
	$(call blue, "# Running Stack...")
	docker-compose up -d

logs:
	$(call blue, "# Outputting Logs...")
	docker-compose logs ${service}

clean-up:
	$(call blue, "# Cleaning Up Environment...")
	docker-compose kill && docker-compose rm -f

clean:
	@rm -f ${app}

define blue
  @tput setaf 4
	@echo $1
	@tput sgr0
endef
