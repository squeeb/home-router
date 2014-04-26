#!/bin/bash
# Move OpenVZ Container script
# otb_chrisr - February 14, 2013
#
# Binary locations
VZCTL=/usr/sbin/vzctl
VZLIST=/usr/sbin/vzlist
VZQUOTA=/usr/sbin/vzquota

# Config locations
VZCONFDIR=/etc/vz/conf/
VZQUOTADIR=/var/lib/vzquota/

# Colours
txtred=$(tput setaf 1)    # red
txtgreen=$(tput setaf 2)  # green
txtrst=$(tput sgr0)     # Reset your text

# flag statuses
sourceFlag=false
destFlag=false
startFlag=false
forceFlag=false

function printHelp() {
  echo "Usage: $0 -s <source container ID> -d <destination container ID> [-c]
  -c = Copy instead of move
  -s = Source VEID
  -d = Destination VEID
  -f = Force, even if I can't find the VZ in vzlist -a
  -S = Start container when done"
}

function die() {
  echo "$2" >&2
  exit $1
}

function ShutDown() {
    echo -n "Shutting down ${SVEID}..."
    ${VZCTL} stop ${SVEID} >/dev/null 2>&1
    if [ ! $? -eq 0 ]; then
      die 1 "${txtred}Could not shut down ${SVEID}. Exiting!${txtrst}"
    fi
    echo "${txtgreen}Done.${txtrst}"
}

function StartUp() {
  ${VZCTL} start ${DVEID}
  if [ $? -eq 0 ]; then
    echo "${txtgreen}Finished!${txtrst}"
  else
    die 1 "${txtred}Failed!${txtrst}"
  fi
}

function MoveRoot() {

    echo -n "Checking source root directory ${SVE_ROOT}..."

    if [ -d ${VE_ROOT}${SVEID} ]; then
      echo "${txtgreen}Found!${txtrst}"
      echo -n "Checking destination directory ${VE_ROOT}${DVEID} is clear..."

      if [ -d ${VE_ROOT}${DVEID} ]; then
        die 1 "${txtred}not clear. Exiting!"
      fi

      echo "${txtgreen}clear!${txtrst}"
      echo -n "Moving ${VE_ROOT}${SVEID} to ${VE_ROOT}${DVEID}..."
      mv ${VE_ROOT}${SVEID} ${VE_ROOT}${DVEID}

      if [ $? -eq 0 ]; then
        echo "${txtgreen}Success!${txtrst}"
      else
        die 1 "${txtred}Failed!${txtrst}"
      fi

    fi
}

function MovePrivate() {
    echo -n "Checking source private directory ${SVE_PRIVATE}..."

    if [ -d ${VE_PRIVATE}${SVEID} ]; then
      echo "${txtgreen}Found!${txtrst}"
      echo -n "Checking destination directory ${VE_PRIVATE}${DVEID} is clear..."

      if [ -d ${VE_PRIVATE}${DVEID} ]; then
        die 1 "${txtred}not clear. Exiting!"
      fi

      echo "${txtgreen}clear!${txtrst}"
      echo -n "Moving ${VE_PRIVATE}${SVEID} to ${VE_PRIVATE}${DVEID}..."
      mv ${VE_PRIVATE}${SVEID} ${VE_PRIVATE}${DVEID}

      if [ $? -eq 0 ]; then
        echo "${txtgreen}Success!${txtrst}"
      else
        die 1 "${txtred}Failed!${txtrst}"
      fi

    fi
}

function MoveQuota() {
    echo -n "Checking source quota file ${SVE_QUOTA}..."
    if [ -e ${SVE_QUOTA} ]; then
      echo "${txtgreen}Found!${txtrst}"
      echo -n "Checking destination quota file ${DVEID} doesn't exist..."
      if [ -e ${DVE_QUOTA} ]; then
        die 1 "${txtred}not clear. Exiting!"
      fi
      echo "${txtgreen}clear!${txtrst}"
      echo -n "Moving ${SVE_QUOTA} to ${DVE_QUOTA}..."
      mv ${SVE_QUOTA} ${DVE_QUOTA}
      if [ $? -eq 0 ]; then
        echo "${txtgreen}Success!${txtrst}"
      else
        die 1 "${txtred}Failed!${txtrst}"
      fi
    else
      echo "${txtgreen}Not found!${txtrst}"
      echo "Do you wish to continue without a valid quota file? [Y|n]"
      read continue
      if [ ${continue} == "n" ]; then
        die 1 "${txtgreen}Stopping by request${txtrst}"
      fi
    fi
    echo -n "Disabling quota for source ${SVEID}..."
    ${VZQUOTA} drop ${SVEID}
    if [ $? -eq 0 ]; then
      echo "${txtgreen}Success!${txtrst}"
    else
      echo "${txtgreen}Failed!${txtrst}"
      echo "Do you wish to continue without a valid quota file? [Y|n]"
      read continue
      if [ ${continue} == "n" ]; then
        die 1 "${txtgreen}Stopping by request${txtrst}"
      fi
    fi
}

function MoveConfig() {
    echo -n "Moving config file ${VZCONFDIR}${SVEID}.conf to ${VZCONFDIR}${DVEID}.conf..."
    mv ${VZCONFDIR}${SVEID}.conf ${VZCONFDIR}${DVEID}.conf
    if [ $? -eq 0 ]; then
      echo "${txtgreen}Success!${txtrst}"
      echo -n "Correcting config file..."
      sed -i "s/\([^0-9]\)${SVEID}\([^0-9]\)/\1${DVEID}\2/" ${VZCONFDIR}${DVEID}.conf >/dev/null 2>&1
      if [ $? -eq 0 ]; then
        echo "${txtgreen}Success!${txtrst}"
      else
        die 1 "${txtred}Failed!${txtrst}"
      fi
    else
      die 1 "${txtred}Failed!${txtrst}"
    fi
}

if [ ! `id -u` -eq 0 ]; then
  echo "This script must be run as root. Exiting!" >&2
fi

while getopts hs:d:cSf opt; do
  case $opt in
    h)
      printHelp
      exit 0
    ;;
    s)
      sourceFlag=true
      SVEID=$OPTARG
      if ! [[ "${SVEID}" =~ ^[0-9]+$ ]]; then
        die 1 "${txtred}The source \"${SVEID}\" is not a valid VEID.${txtrst}"
      fi
    ;;
    S)
      startFlag=true
    ;;
    d)
      destFlag=true
      DVEID=$OPTARG
      if ! [[ "${DVEID}" =~ ^[0-9]+$ ]]; then
        die 1 "${txtred}The destination \"${DVEID}\" is not a valid VEID.${txtrst}"
      fi
    ;;
    c)
      echo "Copy would be enabled"
    ;;
    f)
      forceFlag=true
    ;;

    \?)
      printHelp
    ;;
  esac
done

### do the things

if  ! $sourceFlag ; then
  die 1 "${txtred}-s <source VEID> must be defined${txtrst}"
fi
if  ! $destFlag ; then
  die 1 "${txtred}-d <destination VEID> must be defined${txtrst}"
fi


if [ "${DVEID}x" == "x" ]; then
    die 1 "${txtred}No destination VEID set. Wat?${txtrst}"
fi
if [ "${SVEID}x" == "x" ]; then
    die 1 "${txtred}No source VEID set. Wat?${txtrst}"
fi

### Check source VEID actually exists
echo -n "Checking OpenVZ for the source container \"${SVEID}\"..."

if ! $forceFlag; then
  if [ `$VZLIST -a | awk {'print $1'} | grep ${SVEID} | grep -v grep | wc -l` -lt 1 ]; then
      die 1 "${txtred}Source \"${SVEID}\" not found!${txtrst}"
  else
    echo "${txtgreen}Found!${txtrst}"
  fi
fi

if [ `$VZLIST -a | awk {'print $1'} | grep ${SVEID} | grep -v grep | wc -l` -lt 1 ]; then
  echo "${txtred}Source \"${SVEID}\" not found!${txtrst} Attempting to force anyway!"
else
  echo "${txtgreen}Found!${txtrst}"
fi

sleep 0.5

# Check destination VEID doesn't exist already
echo -n "Checking OpenVZ for the destination container \"${DVEID}\"..."

if [ `$VZLIST -a | awk {'print $1'} | grep ${DVEID} | grep -v grep | wc -l` -lt 1 ]; then
  echo "${txtgreen}clear!${txtrst}"

# Shut down the source
  ShutDown

# Get source VEID current location
  echo -n "Reading config file for ${SVEID}..."

  VEID=${SVEID}
  source ${VZCONFDIR}${SVEID}.conf
  if [ $? -eq 0 ]; then
    echo "${txtgreen}Success!${txtrst}"
  else
    die 1 "${txtred}Failed!${txtrst}"
  fi

  VE_ROOT="`dirname ${VE_ROOT}`/"
  VE_PRIVATE="`dirname ${VE_PRIVATE}`/"

# Move quota file
  SVE_QUOTA="${VZQUOTADIR}quota.${SVEID}"
  DVE_QUOTA="${VZQUOTADIR}quota.${DVEID}"
  MoveQuota

  sleep 0.5

# Move root directory
  SVE_ROOT=${VE_ROOT}${SVEID}
  MoveRoot

  sleep 0.5

# Move private directory    SVE_PRIVATE=${VE_PRIVATE}${SVEID}
  MovePrivate

  sleep 0.5

## Move config file
  MoveConfig

  sleep 0.5

  if ! $startFlag; then
    echo "${txtgreen}Finished!${txtrst}"
  else
    StartUp
  fi

else

  die 1 "${txtred}${DVEID} already exists in OpenVZ. Exiting!${txtrst}"

fi

