#!/bin/bash
# Enable the target user by restoring the password

target_user=${1}

logger "Disabling user: ${target_user}..."

passwd -u ${target_user}

logger "  ... user enabled."
