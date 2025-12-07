#!/bin/bash

# Get necessary vars
target_user=$1
target_uid=$(id -u $target_user)
project_dir=$(dirname -- ${BASH_SOURCE[0]})
lib_dir="$project_dir/lib"

schedule_config="$project_dir/config/schedule.json"
schedule_unlock=$(cat $schedule_config | jq -r '.unlock')
schedule_lock=$(cat $schedule_config | jq -r '.lock')

unlock_ts=$(date --date="$schedule_unlock" +%s)
lock_ts=$(date --date="$schedule_lock" +%s)
notify_ts=$(date --date="@$(($lock_ts-300))" +%s)
current_ts=$(date +%s)

controls_enabled=$(cat $schedule_config | jq -r '.enabled')

## Get current account lock status
case "$(passwd -S $target_user | awk '{print $2}')" in
  "L")
    user_status="locked" ;;
  "P")
    user_status="unlocked" ;;
  *)
    logger "Could not ascertain status of user: $(passwd -S $target_user)"
    logger "... assuming unlocked"
    user_status="unlocked" ;;
esac

## Confirm vars - debug
#logger "Project Path:     ${project_dir}"
#logger "Target User/UID:  ${target_user} / ${target_uid}"
#logger "User Status:      ${user_status}"
#logger "Unlock Time       $(date --date=@$unlock_ts) ($unlock_ts)"
#logger "Lock Time:        $(date --date=@$lock_ts) ($lock_ts)"
#logger "Notify Time:      $(date --date=@$notify_ts) ($notify_ts)"
#logger "Controls Enabled: ${controls_enabled}"

# Quit if controls disabled
if [ "$controls_enabled" = false ]; then
  # Enable user if disabled
  if [ "$user_status" = "locked" ]; then
    /bin/bash $lib_dir/enable_user.sh $target_user
  fi
  exit 0
fi

# Check current time in relation to lock/unlock time
# Assumes the lock time is later in the day than the unlock time
## See if we need to lock
if [ $current_ts -ge $lock_ts ] ; then
  # Check if unlocked
  if [ $user_status = "unlocked" ] ; then
    /bin/bash $lib_dir/libdisable_user.sh $target_user
    /bin/bash $lib_dir/lock_screen.sh $target_user
    exit 0
  fi
## See if we need to unlock
elif [ $current_ts -ge $unlock_ts ] ; then
  # Check if locked
  if [ $user_status = "locked" ] ; then
    /bin/bash $lib_dir/enable_user.sh $target_user
  fi
  # See if we need to notify
  if [ $current_ts -ge $notify_ts ] ; then
    /bin/bash $lib_dir/notify.sh $target_user $lock_ts
  fi
fi
