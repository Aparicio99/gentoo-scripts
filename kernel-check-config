#!/bin/bash

NORMAL="\e[0m"
RED="\e[0;31m"
GREEN="\e[0;32m"
CYAN="\e[0;36m"

function check_var() {
	local check_string=$1

	if [[ ${check_string} =~ ~(\!)?(.*) ]]; then

		not=${BASH_REMATCH[1]}
		name=${BASH_REMATCH[2]}

		config_name="CONFIG_${name}"
		config_value=${!config_name}

		if [[ ${not} == '!' && ${config_value} == 'y' ]]; then
			echo -e "    ${RED}${name}${NORMAL} should NOT be disabled"

		elif [[ ${not} != '!' && ${config_value} != 'y' ]]; then
			echo -e "    ${GREEN}${name}${NORMAL} should be enabled"
		fi
	fi
}

function check_vars() {
	local vars="$1"
	echo -e "Checking $pkg with ${CYAN}$vars${NORMAL}"

	for config in ${vars}; do
		check_var ${config}
	done
}

function check_package() {
	local pkg=$1
	local CONFIG_CHECK=""

	# sed -> black magic needed to delete newlines on lines that not finish with " -> needed to join multi-line delares
	source <(bzcat ${pkg}/environment.bz2 | sed ':a;N;$!ba;s/\([^"]\)\n/\1/g' | sed 's/\t/ /g' | grep "declare -- CONFIG_CHECK")

	[[ "${CONFIG_CHECK}" ]] && check_vars "${CONFIG_CHECK}"

	# Check also local definitions inside functions

	CONFIG_CHECK=""
	eval $(grep "local CONFIG_CHECK" ${pkg}/${pkg#*/}.ebuild 2>/dev/null)

	[[ "${CONFIG_CHECK}" ]] && check_vars "${CONFIG_CHECK}"
}

if [[ -f "$1" ]]; then
	echo "Reading kernel config from $1"
	source $1

elif [[ -f /proc/config.gz ]]; then
	echo "Reading kernel config from /proc/config.gz"
	source <(zcat /proc/config.gz)
else
	echo -e "/proc/config.gz not found. ${GREEN}IKCONFIG${NORMAL} must enabled!"
	exit
fi

cd /var/db/pkg

for category in *; do
	for package in ${category}/*; do
		if [[ -d ${package} ]]; then
			check_package "${package}"
		fi
	done
done

