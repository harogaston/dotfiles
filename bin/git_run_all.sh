#!/bin/bash

usage()
{
  lolban " > git_run_all"
  echo -e "\n"
  echo -e "Usage:\n   git_run_all [-d directory] command\n"
  echo -e "OPTIONS:"
  echo -e " - directory\t default value is '.'"
  echo -e " - command\t the git command to run"
  exit 2
}

YELLOW='\033[1;33m'
NC='\033[0m' # No Color

SRC='.'
while getopts ':d:?h' c
do
  case $c in
    d) SRC=$OPTARG ;;
    h|?) usage ;; esac
done

shift $(($OPTIND-1))

for dir in $( ls -d ${SRC}/* );
do
  cd ${dir} >/dev/null 2>&1
  # check if exit status of above was 0, indication we're in a directory
  if [ $(echo $?) -eq 0 ]; then
	  git status >/dev/null 2>&1
  else continue;
  fi
  # check if exit status of above was 0, indicating we're in a git repo
  [ $(echo $?) -eq 0 ] && echo -e "${YELLOW}--> Running git ${@} in ${dir%*/}...${NC}" && git ${@}
  cd ..
done
