#!/bin/bash


##
## Install grive2 as per http://bit.ly/28InB2O
##


##
## ChangeLog
##
## @author Dr. John X Zoidberg <drjxzoidberg@gmail.com>
## @version 1.1.0
## @date 2017-02-05
##  - first release
##
##
## @author Dr. John X Zoidberg <drjxzoidberg@gmail.com>## @version 1.0.0
## @date 2016-07-21
##  - first release
##


WD="$(dirname "$0")"


cat >"${WD}/grive.settings" <<EOD
PRG_NAME="gdrive-sync"

GROUP=enli32

PREFIX=/usr/local
PREFIX_BIN="${PREFIX}/bin"
PREFIX_SHARE="${PREFIX}/share"
PREFIX_LIB="${PREFIX}/lib${GROUP:+/${GROUP}}"

FILE_PREFIX="${GROUP:+${GROUP}-}"
EXEC_PREFIX="${FILE_PREFIX}"

INTERVAL=5
TIMEOUT=5
GDRIVE_DIR=\~/gdrive
GDRIVE_LOG=\~/\".${GROUP:+${GROUP}/}${PRG_NAME}.log\"
SETTINGS=\~/\".${GROUP:+${GROUP}/}${PRG_NAME}.settings\"
EOD

if [ -r "${WD}/grive.settings.user" ] ; then
  cat "${WD}/grive.settings.user" >>"${WD}/grive.settings"
fi
. "${WD}/grive.settings"



##
## Install: user must be sudoer.
##
install ()
{
  cat <<-EOD
	This will install grive2 and its companions.
	The procedure has been tested on 2017-02-17 on Ubuntu 16.10.
	Dependencies: 
	a) grive from 'ppa:nilarimogard/webupd8' repository;
	b) lockfile-progs from 'official' repository.
EOD
  
  read -p 'Continue [y/N]?' a
  if [ "${a}" != "y" ] ; then
    return 1
  fi

  read -p 'Install dependencies [y/N]?' a
  if [ "${a}" = "y" ] ; then
    sudo add-apt-repository ppa:nilarimogard/webupd8 || return 1
    sudo apt-get update || return 1
    sudo apt-get install grive lockfile-progs || return 1
  fi

  echo "Installing '${PREFIX_BIN}/${EXEC_PREFIX}${PRG_NAME}.sh'."

  rm -fr "${WD}/build"
  mkdir -p "${WD}/build"

  cp ${PRG_NAME}.sh.template "${WD}/build/${EXEC_PREFIX}${PRG_NAME}.sh"
  cp ${PRG_NAME}.cron.template "${WD}/build/${EXEC_PREFIX}${PRG_NAME}.cron"
  cp ${PRG_NAME}.sh.desktop.template "${WD}/build/${EXEC_PREFIX}${PRG_NAME}.sh.desktop"
  IFS=$'\n'
  for p in $(grep -v ^# "${WD}/grive.settings") ; do
    name="${p%%=*}"
    eval value=\"\$${name}\"
    sed -i -e 's:@@'"${name}"'@@:'"${value}"':g' \
      "${WD}/build"/*
#      "${WD}/build/${EXEC_PREFIX}${PRG_NAME}.sh" \
#      "${WD}/build/${PRG_NAME}.cron" \
#      "${WD}/build/${EXEC_PREFIX}${PRG_NAME}.sh.desktop"

  done

  echo sudo install -D "${WD}/build/${EXEC_PREFIX}${PRG_NAME}.sh" "${PREFIX_BIN}/${EXEC_PREFIX}${PRG_NAME}.sh" || return 1
  echo sudo install -D "${WD}/build/${EXEC_PREFIX}${PRG_NAME}.sh.desktop" "${PREFIX_SHARE}/${GROUP}/${PRG_NAME}/${EXEC_PREFIX}${PRG_NAME}.sh.desktop" || return 1
  echo sudo install -D "${WD}/build/${EXEC_PREFIX}${PRG_NAME}.cron" "${PREFIX_SHARE}/${GROUP}/${PRG_NAME}/${EXEC_PREFIX}${PRG_NAME}.cron" || return 1
}



installSync ()
{
  read -p 'Do you want to install sync daemon? [y/N]' a
  if [ "${a}" != "y" ] ; then
    return 1
  fi

  read -p 'What type of daemon Autostart/Cron? [a/c]' a

  if [ "${a}" = "a" ] ; then
    cp "${WD}/build/${EXEC_PREFIX}${PRG_NAME}.sh.desktop" ~/.config/autostart/
    return $?
  fi

  if [ "${a}" = "c" ] ; then
    crontab -l 2>/dev/null | grep -v "^no crontab for ${USER}" | cat - "${WD}/build/${PRG_NAME}.cron"
    return $?
  fi

  return 0
}



init ()
{
  mkdir -p "${GDRIVE_DIR}"
  RES=$?
  if [ ${RES} -ne 0 ] ; then
    echo "[EE] cannot mkdir (${RES}) gdrive dir. '${GDRIVE_DIR}' [\${GDRIVE_DIR}]."
    return 1
  fi

  ## else...

  cd "${GDRIVE_DIR}"
  RES=$?
  if [ ${RES} -ne 0 ] ; then
    echo "[EE] cannot cd (${RES}) gdrive dir. '${GDRIVE_DIR}' [\${GDRIVE_DIR}]."
    return 1
  fi

  ## else...

  grive -a || return 1

  cd "${OLDPWD}"

  installSync
}



##
## MAIN
##

cmd="$1"

case $cmd in
  install)
    install
  ;;

  *)
     echo "usage: $(basename "$0") install"
  ;;
esac

