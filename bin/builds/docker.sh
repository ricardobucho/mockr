#!/usr/bin/env bash

if [ "${*}" == "bundle exec rails server -b 0.0.0.0" ]; then
  bundle exec rails db:create db:migrate
fi

exec "$@"
