src=.

.PHONY: app
app: mandatory-name-arg ## make app [name=<APP NAME>] # Create a new django app called: 'name'
	@cd src && python manage.py startapp --template=../app_template $(name)

EXCLUDES = 'migrations,settings,media,static,templates,manage.py,mocks.py'
.PHONY: lint
lint: ## make lint # PEP8 syntax check
	@flake8 --exclude=$(EXCLUDES) src/

opts	:= $(opts)

ifeq ("$(detach)", "yes")
	opts := $(opts) -d
endif
ifeq ("$(build)", "yes")
	opts := $(opts) --build
endif

ifneq ("$(test-path)", "")
	cargs := $(test-path)
else
	cargs := $(src)
endif
ifeq ("$(tag)", "")
	cargs := $(cargs) --exclude-tag=integration
else ifeq ("$(tag)", "all")
	cargs := $(cargs)
else
	cargs := $(cargs) --tag=$(tag)
endif
ifeq ("$(keepdb)", "yes")
	cargs := $(cargs) --keepdb
endif

.PHONY: test
test: ## make test [detach=no] [keepdb=no] [test-path=.] # Run unit tests
	@docker-compose run \
		--rm \
		-e DJANGO_SETTINGS_MODULE=settings.test \
		$(opts) \
		django \
		python $(src)/manage.py test -t $(src) $(cargs)

.PHONY: ci-test
ci-test: ## make ci-test # Run unit tests as in CI
	@docker-compose -f .circleci/docker-compose.test.yml run \
		--rm \
		--name wait_for_pg \
		--entrypoint sh \
		-e PGPASSWORD=password \
		django \
		-c 'sh /bin/wait-for-postgres.sh postgres test'
	@docker-compose -f .circleci/docker-compose.test.yml run \
		--name ci-test \
		--entrypoint sh \
		-e DJANGO_SETTINGS_MODULE=settings.test \
		django \
		-c 'coverage run $(src)/manage.py test -t $(src) && coverage xml'
	@docker cp ci-test:/app/coverage.xml ./coverage.xml

.PHONY: fg
fg: ## make fg # Start a container session for project
	@docker-compose run --rm --name fg -w /app --entrypoint sh django


docker-repo ?= mydocker
app-name ?= app
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
