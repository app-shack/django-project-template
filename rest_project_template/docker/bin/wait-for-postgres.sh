#!/bin/bash
set -e

host="$1"
user="$2"
shift
shift
cmd="$@"

until psql -h "$host" -U "$user" -c '\l' &> /dev/null; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done

exec $cmd
