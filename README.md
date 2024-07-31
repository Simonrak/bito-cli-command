# Bito Cli Command
## Simple Cli command for Bito
### One-liner install:
        curl https://raw.githubusercontent.com/Simonrak/bito-cli-command/master/.ai.sh | bash
#### How to use:
    1. ai "user input"
    2. ai "user input" /dir/dir/file
    3. ai "user input" /dir/dir/file /dir/dir/context_file

    1. Standard prompt to get a response from Bito
    2. Prompt + file that Bito should look at
    3. Prompt + file + context file for context (api keys or other additional data)
#### Login
    /usr/local/bin/bito
    
    ai() {
    ~/.ai.sh "$@"
    }
