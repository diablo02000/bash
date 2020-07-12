#!/bin/bash

####
## Print debug logs

LOG4BASH_LOG_LEVEL="DEBUG"

# Load log4bash lib
source log4bash.sh

# Print Debug log
log4bash_debug "Print log in DEBUG log level"

# Print Info log
log4bash_info "Print log in INFO log level"

# Print Warnning log
log4bash_warn "Print log in WARN log level"

# Print Error log
log4bash_error "Print log in ERROR log level"
