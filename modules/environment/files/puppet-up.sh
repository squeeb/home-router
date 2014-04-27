#!/bin/bash
fd=0
if [ -t $fd ]; then
  GREEN=`tput setaf 2`
  RED=`tput setaf 1`
  CLEAR=`tput sgr0`
  BOLD=`tput bold`
else
  QUIET='2>&1'
  GITQUIET='--quiet'
fi

function update() {
  if [ $(id -un) == "malkovich" ]; then
    cd /etc/puppet && \
          git pull -p $QUIET && \
          git submodule update --init $QUIET
  else
    cd /etc/puppet && \
          sudo -u malkovich git pull -p $GITQUIET && \
          sudo -u malkovich git submodule update --init $GITQUIET
  fi

  if [ $? -eq 0 ]; then
    echo "[ ${GREEN} ok ${CLEAR} ]";
  else
    echo "[ ${RED} failed ${CLEAR} ]" 1>&2;
  fi
}

update
