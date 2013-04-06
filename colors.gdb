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
# WARNING: This script introduces a number of annoying behaviours into gdb.
#
#    First up, calling backtrace or info threads when no program is running will
#    screw up the output of any following commands because the post hook is
#    never executed (no idea why). To fix this, call cleanup-pipe-file.
#
#    Next, this script uses the logging functionality in gdb so if you're using
#    it to record gdb outputs, this script will break your output whenever you
#    call one of the hook-ed commands.
#
#    Finally, sometimes, when searching through command history (up arrow) the
#    prompt will become borked by including the previous commands. Yet again, I
#    have no idea why this happens.
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

document cleanup-pipe-file
    Disables command redirection and removes the color pipe file.
    Syntax: cleanup-pipe-file
end


#------------------------------------------------------------------------------#
# Prompt
#------------------------------------------------------------------------------#

# \todo I believe this has a tendency to bork the file output.
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
