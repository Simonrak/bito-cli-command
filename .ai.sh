#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: ai 'user input' [data_file] [context_file]"
  exit 1
fi

question="$1"
data_file="$2"
context_file="$3"
temp_file="/home/$USER/bito_ai_generated.txt"

echo "$question" > "$temp_file"

bito_command="bito -p \"$temp_file\""

if [ -n "$data_file" ]; then
  if [ ! -f "$data_file" ]; then
    echo "Data file does not exist: $data_file"
    rm "$temp_file"
    exit 1
  fi
  bito_command="$bito_command -f \"$data_file\""
fi

if [ -n "$context_file" ]; then
  if [ ! -f "$context_file" ]; then
    echo "Context file does not exist: $context_file"
    rm "$temp_file"
    exit 1
  fi
  bito_command="$bito_command -c \"$context_file\""
fi

eval "$bito_command"

rm "$temp_file"
