#! /bin/bash
# Author -- meevs
# Creation Date -- 2023-04-19
# File Name -- steam_workshop_helper_functions
# Notes --
# 	-- These functions depend on the jq json parser

# Author -- meevs
# Creation Date -- 2024-04-19
# Function Name -- parse_mod_ids
# Function Purpose -- Parses the given mod list into a string of workshop ids
# Function Parameters --
# 	-- MOD_LIST -- The modlist to be parsed
# 	-- [SEPARATOR] -- The terminator to be used between mod ids
# Function Returns -- A 
function parse_mod_ids () {
	local ID_LIST=""
	
	if [[ "${#}" -ge 1 ]] then
		local MOD_LIST="${1}"

		if [[ -f "${MOD_LIST}" ]] then
			if [[ "${#}" -ge 2 ]] then
				local SEPARATOR="${2}"
			else # [[ "${#}" -ge 2 ]]
				local SEPARATOR=" "
			fi

			# echo -e "<<INFO>> -- Parsing mod list \e[38;2;200;200;0m${MOD_LIST}\e[0m"
		
			let index=0
			while [[ "$(jq -Mrc .mods[${index}] ${MOD_LIST})"  != "null" ]]
			do
				#jq ".mods[${index}]" "${MOD_LIST}"
	
				# Get mod data
				workshop_id="$(jq -Mrc .mods[${index}].workshop_id ${MOD_LIST})"
	
				# Ensure we have a valid workshop id
				if [[ "${workshop_id}" == "null" ]]
				then
					#echo -e "\e[38;2;255;0;0mNo workshop id provided, skipping mod ${index}!\e[0m"
					((index++))
					continue
				fi

				if [[ -z "${ID_LIST}" ]] then
					ID_LIST="${workshop_id}"
				else
					ID_LIST="${ID_LIST}${SEPARATOR}${workshop_id}"	
				fi

				((index++))
			done
			
			echo "${ID_LIST}"
			return 0
		fi
		return 1
	fi
	return 2
}

# Author -- meevs
# Creation Date -- 2024-04-19
# Function Name -- parse_mod_names
# Function Purpose -- Parses the given mod list into a string of workshop ids
# Function Parameters --
# 	-- MOD_LIST -- The modlist to be parsed
# 	-- [SEPARATOR] -- The terminator to be used between mod ids
# Function Returns -- A 
function parse_mod_names () {
	local ID_LIST=""
	
	if [[ "${#}" -ge 1 ]] then
		local MOD_LIST="${1}"

		if [[ -f "${MOD_LIST}" ]] then
			if [[ "${#}" -ge 2 ]] then
				local SEPARATOR="${2}"
			else # [[ "${#}" -ge 2 ]]
				local SEPARATOR=" "
			fi

			# echo -e "<<INFO>> -- Parsing mod list \e[38;2;200;200;0m${MOD_LIST}\e[0m"
		
			let index=0
			while [[ "$(jq -Mrc .mods[${index}] ${MOD_LIST})"  != "null" ]]
			do
				#jq ".mods[${index}]" "${MOD_LIST}"
	
				# Get mod data
				workshop_name="$(jq -Mrc .mods[${index}].mod_name ${MOD_LIST})"
	
				# Ensure we have a valid workshop id
				if [[ "${workshop_name}" == "null" ]]
				then
					#echo -e "\e[38;2;255;0;0mNo workshop id provided, skipping mod ${index}!\e[0m"
					((index++))
					continue
				fi

				if [[ -z "${ID_LIST}" ]] then
					ID_LIST="${workshop_name}"
				else
					ID_LIST="${ID_LIST}${SEPARATOR}${workshop_name}"	
				fi

				((index++))
			done
			
			echo "${ID_LIST}"
			return 0
		fi
		return 1
	fi
	return 2
}

# Author -- meevs
# Creation Date -- 2024-04-19
# Function Name -- parse_app_id
# Function Purpose -- Parses the app id out of the mod list
# Function Parameters --
# 	-- MOD_LIST -- The mod list that will be parsed
# Function Returns -- void
# Notes --
function parse_app_id () {
	if [[ "${#}" -ge 1 ]] then
		local MOD_LIST="${1}"

		if [[ -f "${MOD_LIST}" ]] then
			jq -Mrc .app_id "${MOD_LIST}"
		fi
	fi
}

# Author -- meevs
# Creation Date -- 2024-04-19
# Function Name -- install_mods
# Function Purpose -- Installs the mods provided in the provided mod list
# Function Parameters --
# 	MOD_LIST -- The mod list to be used in installing mods
# 	[STEAM_LOGIN] -- The login to be used when downloading mods; if no id is provided, defaults to "anonymous"
# Function Returns -- void
# Notes --
function install_mods () {
	local APP_ID=""
	local ID_LIST=""

	if [[ "${#}" -ge 1 ]] then
		local MOD_LIST="${1}"
			if [[ "${#}" -ge 2 ]] then
				local STEAM_LOGIN="${2}"
			else
				read -p "Steam Login: " STEAM_LOGIN
			fi

		APP_ID=$(parse_app_id "${MOD_LIST}")
		ID_LIST=$(parse_mod_ids "${MOD_LIST}")
		echo "<<DBUG>> -- ${STEAM_LOGIN}"
		for mod in $(echo "${ID_LIST}" | sed "s/ / /g")
		do
			echo -e "\e[38;2;255;255;0mDownloading mod ${mod}\e[0m"
			"${STEAMCMD}" +force_install_dir "${PWD}" +login "${STEAM_LOGIN}" +workshop_download_item "${APP_ID}" "${mod}" +quit
			echo ""
		done
		echo ""
	fi	
}

echo ""
echo "MBox Steam Workshop Helper Functions loaded"
echo ""
