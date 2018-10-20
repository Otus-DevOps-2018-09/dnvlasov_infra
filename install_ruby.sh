#1/bin/bash

sudo apt update
sudo apt install -y ruby-full ruby-bundler build-essential
ruby=$(ruby -v)
bundle=$(bundle -v)

echo "------------"
echo "$ruby"
echo "$bundle"



