#!/bin/sh
set -e

/bin/mkdir -p ~/.ssh

if [ ! -z "$SSH_KEY" ]; then
  /bin/echo "[DEBUG] Copying ssh private key from environment ...";
  /bin/echo -e "$SSH_KEY" > ~/.ssh/id_rsa
elif [ ! -f "$SSH_KEY_FILE" ]; then
  /bin/echo "[DEBUG] Copying ssh private key file ...";
  /bin/cp ${SSH_KEY_FILE} ~/.ssh/id_rsa
fi

if [ -f ~/.ssh/id_rsa ]; then
  /bin/echo "[DEBUG] Using ~/.ssh/id_rsa ...";
  /bin/chmod 400 ~/.ssh/id_rsa
  eval $(ssh-agent -s) > /dev/null
  /usr/bin/ssh-add ~/.ssh/id_rsa
fi

/bin/echo -e "Host * \n    StrictHostKeyChecking no" > ~/.ssh/config

if [ ! -z "$REPO" ]; then
  /bin/echo "[INFO  ] Downloading from ${REPO} ...";

  if [ -z "$BRANCH" ]; then
    BRANCH="master";
  fi
  /bin/echo "[INFO  ] ... checking out ${BRANCH}";

  if [ -z "$HASH" ]; then
    HASH="HEAD";
  fi
  /bin/echo "[INFO  ] ... resetting to ${HASH}";

  # We do it this way so that we can abstract if from just git later on
  GITCACHE=$PWD/.git

  if [ ! -d $GITCACHE ]; then
      /bin/echo "[INFO  ] Creating new repository ...";
      /bin/rm -rf * &> /dev/null || /bin/true
      /bin/rm -rf .* &> /dev/null || /bin/true
      /usr/bin/git init .
      /usr/bin/git remote add origin "$REPO"
      /usr/bin/git fetch origin
      /usr/bin/git checkout --force "$BRANCH"
      /usr/bin/git reset --hard "$HASH"
  else
      /bin/echo "[INFO  ] Upgrading repository ...";
      /usr/bin/git fetch origin
      /usr/bin/git checkout --force "$BRANCH"
      /usr/bin/git reset --hard "$HASH"
  fi
fi

/bin/echo "[INFO  ] Found $(find . -path './.git*' -prune -o -type f -name '*' -print | wc -l) files"
/bin/echo "[INFO  ] Found $(find . -path './.git*' -prune -o -type d -name '*' -print | wc -l) dirs"
/bin/echo "[INFO  ] $(du -chd 0 . | tail -1)"