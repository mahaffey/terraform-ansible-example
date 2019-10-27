#!/usr/bin/env bash

set -e

linux_install () {
  PACKAGE="$1"
  YUM_CMD="$(command -v yum)"
  APT_GET_CMD="$(command -v apt-get)"

  if [[ -n $YUM_CMD ]]; then
    yum install $PACKAGE
  elif [[ -n $APT_GET_CMD ]]; then
    apt-get install $PACKAGE
  else
    echo "error! cannot install package $PACKAGE" >&2 && exit 1
  fi
}

if [[ "$(uname)" == "Darwin" ]]; then
  if ! brew list python@3 >/dev/null 2>&1 ; then
    brew install python
  else
    echo "Python3 already installed" >&2
  fi
  if ! brew list terraform >/dev/null 2>&1 ; then
    brew install terraform
  else
    echo "Terraform already installed" >&2
  fi
else
  if ! command -v python >/dev/null 2>&1 ; then
    linux_install python
  else
    echo "Python3 already installed" >&2
  fi
  if ! command -v terraform >/dev/null 2>&1 ; then
    linux_install terraform
  else
    echo "Terraform already installed" >&2
  fi
fi

pip3 install --upgrade --user -r requirements.txt
