#!/bin/sh

pushd $(dirname $0)

ansible-galaxy install -r ./requirements.yml -p ./vendor/roles
# ansible-playbook ./site.yml $@
