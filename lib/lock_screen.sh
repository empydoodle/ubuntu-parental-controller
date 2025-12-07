#!/bin/bash
# Lock the screen of the active user session

target_user=${1}
login_session=$(loginctl list-sessions | grep $target_user | awk '{print $1}')

logger "Locking session for ${target_user} (${login_session})..."

loginctl lock-session ${login_session}

logger "   ... session locked for ${target_user} (${login_session})"
