#!/usr/bin/env bash

case $1 in
  test)
    RAILS_ENV=test rake db:setup && RAILS_ENV=test rspec -c
    ;;
  server)
    if [ ! -z $2 ]; then
      RELOAD=true rails server -p $2
    else
      RELOAD=true rails server
    fi
    ;;
  *)
    echo "Invalid command"
    ;;
esac
