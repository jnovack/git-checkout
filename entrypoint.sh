#!/bin/sh
set -e

mkdir -p ~/.ssh

if [ ! -z "$SSH_PRIVATE_KEY" ]; then
  echo "Copying in ssh private key ...";
  echo -e "$SSH_PRIVATE_KEY" > ~/.ssh/id_rsa
  chmod 400 ~/.ssh/id_rsa

  eval $(ssh-agent) > /dev/null
  ssh-add ~/.ssh/id_rsa
fi

echo -e "Host * \n    StrictHostKeyChecking no" > ~/.ssh/config

if [ ! -z "$REPO" ]; then
  echo "Downloading from ${REPO} ...";

  if [ -z "$BRANCH" ]; then
    BRANCH="master";
  fi
  echo "... checking out ${BRANCH}";

  if [ -z "$HASH" ]; then
    HASH="HEAD";
  fi
  echo "... resetting to ${HASH}";

  # We do it this way so that we can abstract if from just git later on
  GITCACHE=$PWD/.git

  if [ ! -d $GITCACHE ]; then
      echo "Creating new repository ...";
      rm -rf * &> /dev/null || true
      rm -rf .* &> /dev/null || true
      git init .
      git remote add origin "$REPO"
      git fetch origin
      git checkout --force "$BRANCH"
      git reset --hard "$HASH"
  else
      echo "Upgrading repository ...";
      git fetch origin
      git checkout --force "$BRANCH"
      git reset --hard "$HASH"
  fi
fi

echo "$(find . -type f | wc -l) files"
echo "$(find . -type d | wc -l) dirs"
du -chd 0 . | tail -1
