#!bin/bash
cowsay "Welcome stranger, What's your name?"
read name
cowsay "Hello $name!, i am property of $(whoami)"
echo "These are my specs"
bash -c "fastfetch"
