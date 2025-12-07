#!/bin/bash
# Disable the target user by locking the password

target_user=${1}

logger "Disabling user: ${target_user}..."

passwd -l ${target_user}

logger "  ... user disabled."
