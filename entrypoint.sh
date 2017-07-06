#!/bin/sh
set -e

mkdir -p ~/.ssh

if [ ! -z "$SSH_PRIVATE_KEY" ]; then
  echo -e "$SSH_PRIVATE_KEY" > ~/.ssh/id_rsa
  chmod 400 ~/.ssh/id_rsa

  eval $(ssh-agent) > /dev/null
  ssh-add ~/.ssh/id_rsa
fi

echo -e "Host * \n    StrictHostKeyChecking no" > ~/.ssh/config

set -x

REPOSRC=$1
SHA=$2

# We do it this way so that we can abstract if from just git later on
GITCACHE=$PWD/.git

if [ ! -d $GITCACHE ]
then
    rm -rf *
    rm -rf .*
    git init .
    git remote add origin "$REPOSRC"
    git fetch origin "$SHA"
    git reset --hard FETCH_HEAD

else
    git fetch "$REPOSRC"
    git checkout --force "$SHA"
fi

