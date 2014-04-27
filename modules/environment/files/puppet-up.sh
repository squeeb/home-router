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
    cd /etc/puppet && \
          sudo git pull -p $GITQUIET && \
    if [ $? -eq 0 ]; then
      echo "[ ${GREEN} ok ${CLEAR} ]";
    else
      echo "[ ${RED} failed ${CLEAR} ]" 1>&2;
    fi
}

update
