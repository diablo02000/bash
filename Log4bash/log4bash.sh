#!/bin/bash

#####
## Create logging bash library 

# Set output log level.
# The available option are:
# - DEBUG
# - INFO
# - WARN
# - ERROR
# Set default value to INFO.
# Unset LOG4BASH LOG LEVEL is the value is unknown.
declare -r LOG4BASH_AVAILABLE_LOG_LEVEL=("DEBUG" "INFO" "WARN" "ERROR")
[[ ! "${LOG4BASH_AVAILABLE_LOG_LEVEL}" =~ "${LOG4BASH_LOG_LEVEL}" ]] && LOG4BASH_LOG_LEVEL=""

declare -r LOG4BASH_LOG_LEVEL="${LOG4BASH_LOG_LEVEL:=INFO}"

# Define log date format.
# check date man for the available format.
declare -r LOG4BASH_DATE_FMT="${LOG4BASH_DATE_FMT:=%D %X}"

# Define max log message length.
declare -r LOG4BASH_MAX_MESSAGE_LENGTH=100

#########################################################
## Main function

# Get log level index value from available log level list.
function _get_log_level_index(){

	local _value="${1}"

	for i in ${!LOG4BASH_AVAILABLE_LOG_LEVEL[@]};
	do
		if [[ "${LOG4BASH_AVAILABLE_LOG_LEVEL[$i]}" = "${_value}" ]];
		then
			echo "${i}"
			break
		fi
	done
}

########################################################
## Main variables

declare -r LOG4BASH_LOG_LEVEL_INT="$(_get_log_level_index "${LOG4BASH_LOG_LEVEL}")"

# Define log default text formats
declare -r LOG4BASH_DEFAULT_TEXT_FMT="[%s] - %s - %-${LOG4BASH_MAX_MESSAGE_LENGTH}s\n"
declare -r LOG4BASH_DEFAULT_COLOR_TEXT_FMT="[%b%s%b] - %s - %-${LOG4BASH_MAX_MESSAGE_LENGTH}s\n"

# Enable/Disable color mode
declare -r LOG4BASH_ENABLE_COLOR_MODE=${LOG4BASH_ENABLE_COLOR_MODE:=0}

# Define color code
declare -r DEBUG="\e[96m"
declare -r INFO="\e[32m"
declare -r WARN="\e[33m"
declare -r ERROR="\e[31m"
declare -r DEFAULT="\e[0m"

# Select color text format is terminal supports color
# and if user select color mode
declare LOG4BASH_TERMINAL_SUPPORT_COLORS=$(tput colors)

if [[ ${LOG4BASH_TERMINAL_SUPPORT_COLORS} -gt 8 ]] && [[ ${LOG4BASH_ENABLE_COLOR_MODE} -gt 0 ]];
then
	declare -r LOG4BASH_TEXT_FMT="${LOG4BASH_DEFAULT_COLOR_TEXT_FMT}"
	declare -r LOG4BASH_OUTPUT_IN_COLOR=1
else
	declare -r LOG4BASH_TEXT_FMT="${LOG4BASH_DEFAULT_TEXT_FMT}"
	declare -r LOG4BASH_OUTPUT_IN_COLOR=0
fi

# Output formatted log message
function _log4bash_output(){

	local log_lvl="${1}"
	local log_message="${2}"
	local log_lvl_int="$(_get_log_level_index "${log_lvl}")"

	# Declare empty array to store method's parameters
	declare -a _args	

	# Add colors code is output color is enable.
	if [[ ${LOG4BASH_OUTPUT_IN_COLOR} -gt 0 ]];
	then
		_args+=("${!log_lvl}")
		_args+=("${log_lvl}")
		_args+=("${DEFAULT}")
	else
		_args+=("${log_lvl}")
	fi

	# Append date time 
	_args+=("$(date +"${LOG4BASH_DATE_FMT}")")
	_args+=("${log_message}")

	if [[ "${log_lvl_int}" -ge "${LOG4BASH_LOG_LEVEL_INT}" ]];
	then
		printf "${LOG4BASH_TEXT_FMT}" "${_args[@]}"
	fi

}


# Print log in DEBUG lvl
# param: message: Message text to output
function log4bash_debug(){
	local message="${1}"
	_log4bash_output "DEBUG" "${message}"
}

# Print log in INFO lvl
# param: message: Message text to output
function log4bash_info(){
	local message="${1}"
	_log4bash_output "INFO" "${message}"
}

# Print log in Warning lvl
# param: message: Message text to output
function log4bash_warn(){
	local message="${1}"
	_log4bash_output "WARN" "${message}"
}

# Print log n ERROR lvl
# param: message: Message text to output
function log4bash_error(){
	local message="${1}"
	_log4bash_output "ERROR" "${message}"
}
