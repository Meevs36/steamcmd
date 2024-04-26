# Author -- meevs
# Creation Date -- 2024-04-26
# File Name -- Dockerfile
# Notes --

# Steamcmd build
FROM steamcmd/steamcmd:debian  AS steamcmd-base

RUN apt-get update -y\
	&& apt-get install -y jq

COPY "./scripts/steam_workshop_helper_functions.sh" "/etc/profile.d/"
COPY "./scripts/entrypoint.sh" "/usr/bin/entrypoint.sh"

ENTRYPOINT [ "/usr/bin/entrypoint.sh" ]
CMD [ "bash" ]

