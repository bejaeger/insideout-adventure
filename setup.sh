#!/bin/bash

if [ -f ".env" ]; then
  export $(cat .env | xargs)
  echo "successfully setup environment"
else
  echo "Error: cannot setup environment because .env file was not found."
fi