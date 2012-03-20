#!/usr/bin/env bash

cd /home/sbsportal/UniSBS
read -p "Migrate? (Y/n): " ans
case $ans in
Y | y | yes | YES | Yes)
echo "Flying to cliffs of Dover..."
bundle exec rake db:migrate
;;
N | n | no | NO | No)
echo "Sticking with what you know..."
;;
*)
echo "ERROR. Try a straight yes/no answer. You might enjoy it."
exit 1
;;
esac

UNISBS_SERVER_OPTIONS="-p3001"

read -p "Deamonise? (Y/n): " ans
case $ans in
Y | y | yes | YES | Yes)
echo "I see you're a tabloid reader. Starting as deamon..."
UNISBS_SERVER_OPTIONS="$UNISBS_SERVER_OPTIONS -d"
;;
N | n | no | NO | No)
echo "You're one of those liberal types. Starting in terminal..."
;;
*)
echo "ERROR. Try a straight yes/no answer. You might enjoy it."
exit 1
;;
esac

bundle exec rake db:migrate
echo "Serving starter..."
bundle exec rails s $UNISBS_SERVER_OPTIONS
