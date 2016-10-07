#!/usr/bin/env bash

# Test startup file changed detection, update, & restart

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

set -e

info () {
  printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

user () {
  printf "\r  [ \033[0;33m??\033[0m ] $1\n"
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail () {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
}

cd "${INSTALL_DIR}"

info 'Checking to see if local startup script has changed...'
current_git_sha=$(git rev-parse HEAD)
curl_url="https://api.github.com/repos/jo12bar/medimap-viewer--NOMC-config/compare/jo12bar:${current_git_sha}...jo12bar:HEAD"
jq_program="if .files[].filename == \"startup.local.bash\" then true else false end"
changed_files_processed=$(curl -H 'Accept: application/vnd.github.v3+json' "${curl_url}" | jq "${jq_program}")
if [[ "${changed_files_processed}" == *"true"* ]]; then
  info 'Local startup script has been changed!'
  info 'Going to update code, then restart.'
  git pull origin master
  reboot
else
  info 'Local startup file unchanged!'
fi

info 'Updating local config'
git pull origin master
