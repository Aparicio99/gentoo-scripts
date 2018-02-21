#!/usr/bin/gawk -f

function usage() {
	print "diff-configs.awk <config1> <config2> [<kernel directory>]"
	print "This program checks if the config2 file is at the root of the kernel source directory."
	print "If not found you need to pass the kernel directory as the third argument."
	exit
}

BEGIN {

	if (ARGC < 3)
		usage()

	CONFIG1 = ARGV[1]
	CONFIG2 = ARGV[2]

	if (ARGC >= 4)
		DIR = ARGV[3]
	else
		"dirname " CONFIG2 | getline DIR

	if ((getline < (DIR"/Kconfig")) == 1) {
		print "Found " DIR "/Kconfig. Reading Kernel symbols from here.\n"
	} else {
		print "Could not find Kconfig in " DIR
		usage()
	}

	print CONFIG1 "\t\t" CONFIG2 

	while ("find "DIR" -name \"Kconfig*\"" | getline) {
			file = $0
			while (getline < file) {
				if ($1 == "config" || $1 == "menuconfig") {
					var = "CONFIG_" $2
				} else if (($1 == "bool" || $1 == "string" || $1 == "tristate" || $1 == "int" || $1 == "hex") && $2) {
					config[var] = 1
				}
			}
	}

	while ("diff " CONFIG1 " " CONFIG2 | getline) {
		if (/^(<|>) CONFIG/) {
			sub(">", "\t\t\t\t\t\t ")
			sub("<", " ")
			var=$1
			sub("=.*", "", var)
			if (var in config)
				print
		}
	}
}
