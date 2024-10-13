#!/bin/bash

# Variables
RESOURCE_GROUP="DemoRG"

az group delete --name $RESOURCE_GROUP --yes --no-wait