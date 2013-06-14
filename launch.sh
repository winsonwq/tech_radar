#!/usr/bin/env bash

case $1 in
  test)
    RAILS_ENV=test RELOAD=false rake db:setup && RAILS_ENV=test RELOAD=false rspec -c
    ;;
  server)
    if [ ! -z $2 ]; then
      rails server -p $2
    else
      rails server
    fi
    ;;
  *)
    echo "Invalid command"
    ;;
esac
