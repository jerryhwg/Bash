#!/bin/bash

# an associative array
declare -A options
options[ARG_A]=0

# the associative array options can be passed as reference to
# the function parse_options to modify as per user's choice

# show a menu of options to the user if no parameter is given
# otherwise do nothing here
show_options() {
	# if no param is given, display a menu and then exit
	(( $# < 1 )) && {
		# display a menu of options
		echo "     MAIN MENU"
		echo
		echo " -a    select me to enable a service"
		echo " -c    <data>  service that requires data"
		exit 1
	}
}

# parse command line options from the user's choice
parse_options() {

	# getopts <opt_spec> <opt_var> <opt_data>

	# option -a is a flag for boolean choice in your script
	# option -c requires user-provided data
	# option -b is not valid because it is not in ":ac:"

	# in case of error, getopts continues anyway, terminate it manually

	# The order of processing based on the order of the data
	# the user provided on the command line
	# Use:
	# ./backup.sh -a -c cat

	while getopts :ac: opt
	do
		case $opt in
			a)
				# a flag to indicate the option is selected
				options[ARG_A]=1
				echo "options[ARG_A] is set"
				;;
			c)
				options[arg_c]=$OPTARG
				echo "options[arg_c] is set to \"${options[arg_c]}\""
				;;
		esac
	done
}

enable_feature_a() {
	echo "feature a enabled"
}

corp_backup() {
	echo "corp backup"
}

local_backup() {
	echo "local backup"
}

# This run function will only works on the variable set by the
# parse_option()
run() {
	(( ${options[ARG_A]} == 1 )) && {
		# run this with this option selected
		enable_feature_a
	}

	# by default, arg_c should be an empty string when not defined
	case ${options[arg_c]} in
	corp_backup)
		# backup data to corp datacenter
		corp_backup
		;;
	local_backup)
		# copy to a second hdd in the local computer
		local_backup
		;;
	esac

	# a window for the trap code (verify)
	while :; do
		sleep 120
	done
	# replace the above endless loop with the processing
	# logics for a system automation or application
}

exit_confirmed=0 # (verify)
clean_up() {
	(( exit_confirmed == 0 )) && {
		exit_confirmed=1
		echo "Are you sure? Ctrl+C again to exit"
		return 0
	}

	# Begin clean-up here
	exit 1 # general error
}

register_signal_handlers() {
	trap clean_up INT TERM # run clean_up() when Ctrl+C
}

main() {
	show_options "$@" # show all options

	# parse_options will parse all of the selected options to
	# set the flags and variables accordingly
	parse_options "$@"

	# no command line option beyond this point
	register_signal_handlers

	run
}

main "$@" # bootstrap main() when this script is executed

'
Usage:
./backup.sh -a -c <corp_backup|local_backup>
'