#! /bin/bash
# Author -- meevs
# Creation Date -- 2024-04-26
# File Name -- entrypoint.sh

source "/etc/profile.d/steam_workshop_helper_functions.sh"

if [[ "${#}" -ge 1 ]] then
	/bin/bash -c "${1}"
fi
