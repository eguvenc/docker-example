# default target
.DEFAULT_GOAL := help

DC = docker compose

help:
	@echo ""
	@echo "🚀 All commands:"
	@echo "  make build     → Rebuild docker image"
	@echo "  make up        → Start containers in the background"
	@echo "  make down      → Stop and delete containers"
	@echo "  make logs      → Watch live logs"
	@echo "  make clean     → Delete all cache and containers"
	@echo ""

build:
	$(DC) build

up:
	$(DC) up -d

down:
	$(DC) down

logs:
	$(DC) logs -f

clean:
	$(DC) down -v --rmi all --remove-orphans
