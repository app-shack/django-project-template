

## The Makefile targets

Running `make help` will output available make targets.

```
make help
>>>
app                            make app [name=<APP NAME>] # Create a new django app called: 'name'
build                          make build [app-name=app] # Create a docker image from the projects Dockerfile
lint                           make lint # PEP8 syntax check
publish                        make publish [target-image=mydocker/app] [tag=latest] # Push given tag to docker cloud
tag-image                      make tag-image [src=<app-name>] [target-image=mydocker/app] [tag=latest] # Create a tag 'target-image' that refers to 'src'
```

Remember that it could be helpful to change the default values initially in the Makefile for:

* `docker-repo`
* `app-name`

As these values tends to differentiate between projects.

## Installation

```
pip install -r requirements/base.txt
```
