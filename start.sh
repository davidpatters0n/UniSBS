#!/usr/bin/env bash

UNISBS_SERVER_OPTIONS="-p3001"

read -p "Deamonise? (Y/n): " ans
case $ans in
Y | y | yes | YES | Yes)
echo "Starting as deamon..."
UNISBS_SERVER_OPTIONS="$UNISBS_SERVER_OPTIONS -d"
;;
N | n | no | NO | No)
echo "Starting in terminal..."
;;
*)
echo "ERROR. Try a straight answer. You might enjoy it."
exit 1
;;
esac

cd /home/sbsportal/UniSBS
echo "Migrations..."
bundle exec rake db:migrate
echo "Server..."
bundle exec rails s $UNISBS_SERVER_OPTIONS

