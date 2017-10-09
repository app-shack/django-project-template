Deploying
=========

A Makefile is wrapped around ansible to minimize and simplify running deploy scripts
with ansible.

## Dependency installation

`pip install ansible` (v2.4)

### Optional

`pip install ansible-cmdb`

## The Makefile targets

Running `make help` will output available make targets.

```
make help
>>>
cmdb                           make cmdb # Create HTML inventory report
dry-run                        make dry-run [playbook=playbook] [env=inventories/hosts] [tags=<ansible tag>] [limit=<ansible host limit>] [opts=<ansible-playbook arguments>] # Run a playbook in dry run mode
facts                          make facts group=all [env=inventories/hosts] [opts=<ansible arguments>] # Gather facts from your hosts
list-tags                      make list-tags # List all available tags
list                           make list [env=inventories/hosts] # List hosts inventory
run                            make run [playbook=playbook] [env=inventories/hosts] [tags=<ansible tag>] [limit=<ansible host limit>] [opts=<ansible-playbook arguments>] # Run a playbook
```

`make run` is the target to use for triggering a playbook on a group given by `limit=local,xenials`.
Default values for arguments are as follows:

| target    | env(inventory)    | playbook | vault-password-file | limit | tags | verbosity | group |
|:---------:|:-----------------:|:--------:|:-------------------:|:-----:|:----:|:---------:|:-----:|
| run       | inventories/hosts | playbook | .vault_pass.txt     | all   | None | None      | _NA_  |
| dry-run   | ”                 | ”        | ”                   | ”     | ”    | ”         | _NA_  |
| list      | ”                 | _NA_     | _NA_                | _NA_  | _NA_ | _NA_      | _NA_  |
| list-tags | ”                 | playbook | _NA_                | _NA_  | _NA_ | _NA_      | _NA_  |
| facts     | ”                 | _NA_     | _NA_                | _NA_  | _NA_ | _NA_      | all   |
| cmdb      | _NA_              | _NA_     | _NA_                | _NA_  | _NA_ | _NA_      | _NA_  |

It's also possible to add `--extra-vars` with the following argument:

`opts=--skip-tags=live --forks=6`


## Virtual machine

There is also a _Vagrant_ file which is targeted by the `local` host group. Hence
it's possible to start up the project in a local environment.

It's necessary to have Vagrant installed, hance follow [this download link.](https://www.vagrantup.com/downloads.html)

i.e.

```
vagrant up # Boot the VM
make run limit=local playbook=provision # Provision with base packages
make run limit=local playbook=playbook # Start application(s)
```
