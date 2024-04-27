# Author -- meevs
# Creation Date -- 2024-04-26
# File Name -- Dockerfile
# Notes --

# Steamcmd build
FROM steamcmd/steamcmd:debian  AS steamcmd-base

ARG WORKSHOP_HELPER_FUNCTIONS="steam_workshop_helper_functions.sh"

ENV STEAMCMD="steamcmd"
ENV STEAM_WORKSHOP_HELPER_FUNCTIONS="/etc/profile.d/${WORKSHOP_HELPER_FUNCTIONS}"

RUN apt-get update -y\
	&& apt-get install -y jq

COPY "./scripts/${WORKSHOP_HELPER_FUNCTIONS}" "/etc/profile.d/"

ENTRYPOINT [ "/bin/bash" ]
