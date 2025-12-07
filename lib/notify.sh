#!/bin/bash

# Notify user of impending lock

target_user=${1}
lock_ts=${2}

user_id=$(id -u $target_user)
user_dbus="unix:path=/run/user/${user_id}/bus"

current_ts=$(date +%s)
secs_remaining=$(($lock_ts-$current_ts))
msg="Locking in $(($secs_remaining/60)) minutes ($(date --date=@$lock_ts))"

su $target_user -c "DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=$user_dbus \
  notify-send -i lock -u critical -a \"Ubuntu Parental Controls\" \
  \"Ubuntu Parental Controls\" \"${msg}\""
