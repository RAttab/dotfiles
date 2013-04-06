################################################################################
# colors.gdb
# Rémi Attab (remi.attab@gmail.com), 5 Apr 2013
# FreeBSD-style copyright and disclaimer apply
#
# gdb script that colorizes the output of several gdb function.
#
# It accomplishes this feat by adding a hook the select gdb functions and
# redirecting the output of the function into a temp file int the current
# folder. In the post hook for the same function, this file is read back and
# piped through ungodly sed commands which colorizes the output.
#
# It also colorizes the prompt as an extra bonus.
#
# Currently supported gdb functions include:
# - backtraces
# - info threads
#
################################################################################


#------------------------------------------------------------------------------#
# Utils
#------------------------------------------------------------------------------#

define setup-pipe-file
    shell rm -f ./.gdb-color-pipe
    set logging redirect on
    set logging on ./.gdb-color-pipe
end

define cleanup-pipe-file
    set logging off
    set logging redirect off
    shell rm -f ./.gdb-color-pipe
end


#------------------------------------------------------------------------------#
# Prompt
#------------------------------------------------------------------------------#

set prompt \033[01;34m(gdb) \033[01;00m


#------------------------------------------------------------------------------#
# backtrace
#------------------------------------------------------------------------------#

define hook-backtrace
    setup-pipe-file
end

define hookpost-backtrace
    # 1. Function names and the class they belong to
    # 2. Function argument names
    # 3. Stack frame number
    # 4. File path and line number
    shell cat ./.gdb-color-pipe | \
	sed -r "s_([^<])(\b([a-zA-Z0-9_]+::)?[a-zA-Z0-9_?]+)( ?)\(_\1$(tput setaf 3)$(tput bold)\2$(tput sgr0)\4(_g" | \
	sed -r "s_([a-zA-Z0-9_#]*)=_$(tput setaf 4)$(tput bold)\1$(tput sgr0)=_g" | \
	sed -r "s_^(#[0-9]*)_$(tput setaf 1)$(tput bold)\1$(tput sgr0)_" | \
	sed -r "s_(\.*[/A-Za-z0-9\+_\.\-]*):([0-9]+)\$_$(tput setaf 2)\1$(tput sgr0):$(tput setaf 6)\2$(tput sgr0)_g"

    cleanup-pipe-file
end


#------------------------------------------------------------------------------#
# info threads
#------------------------------------------------------------------------------#

define info hook-threads
    setup-pipe-file
end

define info hookpost-threads
    # 1. Function names
    # 2. Function argument names
    # 3. thread id and selected thread
    # 4. File path and line number
    shell cat ./.gdb-color-pipe | \
	sed -r "s_([^<])(\b([a-zA-Z0-9_]+::)?[a-zA-Z0-9_?\.@]+)( ?)\(_\1$(tput setaf 3)$(tput bold)\2$(tput sgr0)\4(_g" | \
	sed -r "s_([a-zA-Z0-9_#]*)=_$(tput setaf 4)$(tput bold)\1$(tput sgr0)=_g" | \
	sed -r "s_^([ \*]) ([0-9]+)_$(tput bold)$(tput setaf 6)\1 $(tput setaf 1)\2$(tput sgr0)_" | \
	sed -r "s_(\.*[/A-Za-z0-9\+_\.\-]*):([0-9]+)\$_$(tput setaf 2)\1$(tput sgr0):$(tput setaf 6)\2$(tput sgr0)_g"
    cleanup-pipe-file
end
