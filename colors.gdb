################################################################################
# Experimental colorization of various gdb outputs
################################################################################

# Prompt
set prompt \033[01;34m(gdb) \033[01;00m

# Bracktrace

define hook-backtrace
    echo -----------------------------------------------------------------------\n
    shell rm -f /tmp/gdb-color-pipe
    set logging redirect on
    set logging on /tmp/gdb-color-pipe
end


# \todo Still need a way to colorize the function name.
# Should probably try to decrapify the function name as well...
define hookpost-backtrace
    set logging off
    set logging redirect off
    shell cat /tmp/gdb-color-pipe | \
        sed -r "s_^(#[0-9]*)_$(tput setaf 1)$(tput bold)\1$(tput sgr0)_" | \
	sed -r "s_:([0-9]*)\$_:$(tput setaf 2)$(tput bold)\1$(tput sgr0)_" | \
	sed -r "s_(/[A-Za-z0-9\+_\.\-]*)_$(tput setaf 3)$(tput bold)\1$(tput sgr0)_g" | \
	sed -r "s_ (in|at) _ $(tput setaf 6)$(tput bold)\1$(tput sgr0) _g"
    shell rm -f /tmp/gdb-color-pipe
    echo -----------------------------------------------------------------------\n
end


