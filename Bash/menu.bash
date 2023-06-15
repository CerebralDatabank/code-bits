#!/bin/bash
choice=1
input=""
while [[ "$choice" != 0 ]]
do
  clear
  case $choice in
    1)
      echo $' Menu '
      echo $'  \e[7m Option 1 \e[27m'
      echo $'   Option 2 '
      echo $'   Option 3 '
      ;;
    2)
      echo $' Menu '
      echo $'   Option 1 '
      echo $'  \e[7m Option 2 \e[27m'
      echo $'   Option 3 '
      ;;
    3)
      echo $' Menu '
      echo $'   Option 1 '
      echo $'   Option 2 '
      echo $'  \e[7m Option 3 \e[27m'
      ;;
  esac
  read -rsn 1 input
  if [[ "$input" != $'\e' ]]; then
    if [[ "$input" == $'' ]]; then
      # Pressing Enter yields empty input
      echo "Done?"
      break
    else
      continue
    fi
  fi
  $ If escape char, read rest of escape sequence
  read -rsn 2 input
  if [[ "$input" == "[A" ]]; then
    choice=$((choice - 1))
  elif [[ "$input" == "[B" ]]; then
    choice=$((choice + 1))
  else
    :
  fi
  if [[ $choice -eq 0 ]]; then
    choice=3
  elif [[ $choice -eq 4 ]]; then
    choice=1
  else
    :
  fi
done
echo "Done! Choice was $choice"
