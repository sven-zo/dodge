#!/bin/bash

set -e #quit on error

#sshpass -p $PASS ssh -o StrictHostKeyChecking=no $USERHOST
#echo "Travis got tha power" >> hello.txt
#exit

#Found this gem: https://gist.github.com/nickbclifford/16c5be884c8a15dca02dca09f65f97bd
#I had some struggles tho, this stuff helped me as well
#https://www.ssh.com/ssh/copy-id
#https://docs.travis-ci.com/user/encrypting-files/
#Never run travis encrypt-file with sudo!!

eval "$(ssh-agent -s)" # Start ssh-agent cache
chmod 600 .travis/id_rsa # Allow read access to the private key
ssh-add .travis/id_rsa # Add the private key to SSH

ssh -T travisci@bitesized.xyz <<EOF
  cd $DEPLOY_DIR
  ls
  echo $PASS | sudo -S git pull
  echo $PASS | sudo -S docker-compose stop
  echo $PASS | sudo -S docker-compose rm -f
  echo $PASS | sudo -S docker-compose build --no-cache
  echo $PASS | sudo -S docker-compose up -d
EOF
