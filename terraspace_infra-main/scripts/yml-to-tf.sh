#!/bin/bash

read -r -p "Enter source yaml file path: " yaml
read -r -p "Enter destination tf file path: " tf
tfk8s -f "$yaml" -o "$tf"
