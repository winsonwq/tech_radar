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
  deploy)
    git pull --rebase && RAILS_ENV=production RELOAD=false rake db:reset && touch tmp/restart.txt
    ;;
  *)
    echo "Invalid command"
    ;;
esac
