
.PHONY: app
app: mandatory-name-arg ## make app [name=<APP NAME>] # Create a new django app called: 'name'
	@cd src && python manage.py startapp --template=../app_template $(name)

EXCLUDES = 'migrations,settings,media,static,templates,manage.py,mocks.py'
.PHONY: lint
lint: ## make lint # PEP8 syntax check
	@flake8 --exclude=$(EXCLUDES) src/

docker-repo ?= mydocker
app-name ?= app
src ?= $(app-name)
target-image ?= $docker-repo/$(app-name)
tag ?= latest

.PHONY: build
build: ## make build [app-name=app] # Create a docker image from the projects Dockerfile
	@docker build -t $(app-name) .

.PHONY: tag-image
tag-image: ## make tag-image [src=<app-name>] [target-image=mydocker/app] [tag=latest] # Create a tag 'target-image' that refers to 'src'
	@echo "Create tag $tag from $(app-name)"
	@docker tag $(src) $(target-image):$(tag)

.PHONY: publish
publish: ## make publish [target-image=mydocker/app] [tag=latest] # Push given tag to docker cloud
	@echo "Publish $(target-image):$(tag) to $(docker-repo)"
	@docker push $(target-image):$(tag)

.PHONY: mandatory-name-arg
mandatory-name-arg:
	@([ ! -z $(name) ]) || (echo "Mandatory 'name' argument required")

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help
