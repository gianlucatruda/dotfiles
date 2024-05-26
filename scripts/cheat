#!/usr/bin/env bash
# cht.sh utility script
# Adapted from ThePrimeagen: https://www.youtube.com/watch?v=hJzqEAf2U4I

# All the utilities and languages you want to suggest
utils=`compgen -c` 
langs=`echo "python golang c cpp javascript typescript lua bash html latex" | tr ' ' '\n'`

selection=`printf "$langs\n$utils" | fzf`
read -p "Query: " query

if printf "$langs" | grep -qs "^$selection$"; then
  Q=$(echo "$query" | tr ' ' '+')
  URL="cht.sh/$selection/$Q"
else 
  Q=$(echo "$query" | tr ' ' '+')
  URL="cht.sh/$selection~$Q"
fi

# Debugging mode if --debug or -d flag
debug=0
for arg in "$@"; do 
  if [[ $arg == "--debug" || $arg == "-d" ]]; then
    debug=1
  fi
done
if [[ $debug -eq 1 ]]; then
  echo "DEBUG: $URL"
  curl $URL
else # bat (pretty output) with forced pagination, so you have to hit q to exit
  curl -s $URL | bat --paging=always
fi
