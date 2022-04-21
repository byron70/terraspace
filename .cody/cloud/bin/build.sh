#!/bin/bash

set -eu

# will build from /tmp because terraspace/Gemfile may interfere
cd /tmp

export PATH=~/bin:$PATH # ~/bin/terraspace wrapper

export TS_ORG=boltops

set -x
terraspace new project infra --plugin none --examples
cd infra

bundle # branch: cloud for both project and `terraspace test` later. app/stacks/demo/test/Gemfile

# type terraspace
cat Gemfile

terraspace new test demo --type stack
cd app/stacks/demo
cd test
bundle
cd -

cd test
bundle exec rspec -b

# terraspace test
