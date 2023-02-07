#!/bin/bash

if [ -f ".env" ]; then
  export $(cat .env | xargs)
  echo "successfully setup environment"
else
  echo ".env file not found. Exiting..."
fi