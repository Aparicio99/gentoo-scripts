#!/bin/bash

VERSIONS="minimal physical virtual generic test"

function usage() {
	echo "Usage: $0 (add|remove|copy) <original kernel directory> [<new kernel directory>]"	
	echo "  add <kernel directory>:      Creates a new set of overlays for the given kernel."
	echo "  remove <kernel directory>:   Removes the set of overlays for the given kernel."
	echo "  copy <from> <to>:            Copies the .config files from one set of overlays to another."
	exit
}

function add() {
	for dir in $OVERLAY $LOWER $UPPER $WORK; do
		if [[ ! -d $dir ]]; then
			mkdir $dir
		fi
	done

	grep ${OVERLAY} /etc/fstab >/dev/null
	if [[ $? != 0 ]]; then
		echo "none	${OVERLAY}	overlay		lowerdir=${LOWER},upperdir=${UPPER},workdir=${WORK}	0 0" >> /etc/fstab
	fi

	grep ${OVERLAY} /proc/self/mounts >/dev/null
	if [[ $? != 0 ]]; then
		mount ${OVERLAY}
	fi
}

function remove() {
	grep ${OVERLAY} /proc/self/mounts >/dev/null
	if [[ $? == 0 ]]; then
		umount ${OVERLAY}
	fi

	sed -i "/${COPY}/d" /etc/fstab

	for dir in $OVERLAY $WORK/work $WORK; do
		if [[ -d $dir ]]; then
			rmdir $dir
		fi
	done
}

function copy() {
	FROM=${1}/.config
	TO=${2}/.config

	grep ${2} /proc/self/mounts >/dev/null
	if [[ $? != 0 ]]; then
		echo "${2} must be mounted before copying the .config file. Is everything alright?"
		echo "Run '$0 add $KERNEL2' to unsure it is mounted before running run this again."
		exit
	fi

	if [[ ! -f $FROM ]]; then
		echo "There is no .config in ${1}."
		return
	fi

	if [[ -f $TO ]]; then
		echo "The .config already exists in ${2}. Copy it manually if you want."
		return
	fi

	cp -n ${FROM} ${TO}
}

if [[ $# -lt 2 ]]; then
	usage
fi

CMD="$1"
KERNEL="${2%/}"
KERNEL2="${3%/}"
LOWER=/usr/src/${KERNEL}

if [[ ! -d $LOWER ]]; then
	echo "Kernel directory '$LOWER' does not exist!"
	exit
fi

for ver in $VERSIONS; do

	COPY=${KERNEL}-${ver}
	OVERLAY=/usr/src/${COPY}
	UPPER=/usr/src/overlayfs_dirs/${COPY}-upper
	WORK=/usr/src/overlayfs_dirs/${COPY}-work

	if [[ $CMD == "add" ]] ; then
		add
	elif [[ $CMD == "remove" ]] ; then
		remove
	elif [[ $CMD == "copy" && "$KERNEL2" ]] ; then
		copy ${OVERLAY}  /usr/src/${KERNEL2}-${ver}
	else
		usage
	fi
done

if [[ $CMD == "remove" ]] ; then
	echo "Directories /usr/src/overlayfs_dirs/*-upper were not deleted to avoid losing the .config files. Delete them manually if you want."
fi

echo "Success."
