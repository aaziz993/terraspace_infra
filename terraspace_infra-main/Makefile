# Fill in your default here, setting from command line will override
# layering variables
type?=project
kind?=terraform
region ?=asia-central
account ?=ai

# Built-in Variables in terraspace can be used as var="<%= builtInVar %>" or combined as var="<%= expansion('builtIn vars combination') %>"
# Built-in variables:
# - :PROJECT
# - :TYPE_DIR
# - :APP
# - :ROLE
# - :MOD_NAME
# - :ENV
# - :EXTRA
# - :REGION
# Example "<%= :PROJECT %>"
# Example "<%= expansion(':PROJECT/:TYPE_DIR/:APP/:ROLE/:MOD_NAME/:ENV/:EXTRA/:REGION') %>"

setup-check:
	terraspace setup check

# Up all using base.tfvars, env.tfvars and env-extra.tfvars layers
# env can be used in tfvars as (variable = "<%= Terraspace.env %>")
# extra can be used in tfvars as (variable = "<%= Terraspace.extra %>")
up:
	if [ -n "$$stacks" ]; then \
        for s in $(stacks); do \
        	terraspace up "$$s" -y; \
        done \
        else \
        terraspace all up -y; \
	fi

# Down all in given environment, region and account layer
down:
	if [ -n "$$stacks" ]; then \
        for s in $(stacks); do \
        	terraspace down "$$s" -y; \
        done \
        else \
        terraspace all down -y; \
	fi

plan:
	terraspace all plan

# Create terraspace shim. A shim wrapper ensures that bundle exec is prepended in front of terraspace when you’re within a project. You only have to set up the shim once.
new-shim:
	terraspace new shim

# Generates new module
new-module:
	terraspace new module $(name)

# Generates new stack
new-stack:
	terraspace new stack $(name)

 # Generates helper for stack
new-helper:
	terraspace new helper $(name) --type $(type)

# Generates hook
new-hook:
	terraspace new hook $(name) --type $(type) --kind $(kind)

# Generates arg
new-arg:
	terraspace new arg $(name) --type $(type)

# The terraspace seed command creates starter tfvars files for you.
new-tfvars:
	terraspace seed $(name)

# Show available stacks
list:
	terraspace list

# Initialize terraform.
# Download providers.
init:
	terraform init

# Build and show found layers, which is what you want to see most of the time.
build:
	terraspace build $(name)

# Run terraspace bundle to download the modules.
bundle:
	terraspace bundle

# Remove cache and log
clear:
	rm -r .terraspace-cache & rm -r log || clear
