#!/bin/bash
# spinner <string> <iterations>
spinner() {
  printf "$1 /"
  for i in $(seq $2)
  do
    sleep 0.2
    printf "\e[D-"
    sleep 0.2
    printf "\e[D\\"
    sleep 0.2
    printf "\e[D|"
    sleep 0.2
    printf "\e[D/"
  done
  printf "\e[D\u2713\n"
}
