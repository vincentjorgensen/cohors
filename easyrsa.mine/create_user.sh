#!/bin/bash
set -e

export NEW_USER=$1

pushd ./easyrsa3

easyrsa build-client-full $NEW_USER nopass

if [ -s pki/issued/$NEW_USER.crt ] ; then
  ./create_configs.sh $NEW_USER
else
  echo `pwd`/pki/issued/$NEW_USER.crt is empty or missing.
  exit 1
fi
