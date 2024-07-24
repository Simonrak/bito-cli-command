#!/bin/bash

BASE_URL="https://github.com/gitbito/CLI/tree/main"
ACCESS_KEY_URL="accesskey.txt"
TARGET_LOCATION="/usr/local/bin/bito"
SCRIPT_PATH="/home/$USER/.ai.sh"
DIR_PATH="/home/$USER/.bitoai/etc"
FILE_PATH="$DIR_PATH/bito-cli.yaml"

HTML=$(curl -s -L "${BASE_URL}")
LATEST_VERSION=$(echo "$HTML" | grep -oP 'version-\d+\.\d+' | sort -V | tail -n 1)

if [ -z "$LATEST_VERSION" ]; then
  echo "No version found."
  exit 1
fi

FILE_URL="https://raw.githubusercontent.com/gitbito/CLI/main/${LATEST_VERSION}/bito-linux-x86"

curl -L -o /tmp/bito-linux-x86 "$FILE_URL"

sudo mv /tmp/bito-linux-x86 "$TARGET_LOCATION"
sudo chmod u+x "$TARGET_LOCATION"

ACCESS_KEY=$(curl -s -L "$ACCESS_KEY_URL")

if [ -z "$ACCESS_KEY" ]; then
  echo "No access key found."
  exit 1
fi

cat << 'EOF' > "$SCRIPT_PATH"
#!/bin/bash

if [ -z "$1" ]; then
  echo "ai 'user input'"
  echo "ai 'user input' [/dir/dir/file]"
  echo "ai 'user input' [/dir/dir/file] [/dir/dir/context_file]"
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
EOF

chmod u+x "$SCRIPT_PATH"

mkdir -p "$DIR_PATH"

cat << EOF > "$FILE_PATH"
bito:
  access_key: $ACCESS_KEY
  email: first.simon.raket@gmail.com
  preferred_ai_model: BASIC
settings:
  auto_update: true
  max_context_entries: 20
EOF

printf '\nAdd to ~/.zshrc:\n\nai() {\n   ~/.ai.sh "$@"\n}\n\n'
