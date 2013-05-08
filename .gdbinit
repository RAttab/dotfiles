################################################################################
# Random tweaks that makes my gdb life easier.
################################################################################

source ~/dotfiles/stl-views.gdb
source ~/dotfiles/dasdb.gdb
source ~/dotfiles/jml.gdb
source ~/dotfiles/colors.gdb


set disassembly-flavor intel

#
# C++ related beautifiers
#

set print pretty on
set print object on
set print static-members on
set print vtbl on
set print demangle on
set print asm-demangle on
set demangle-style gnu-v3
set print sevenbit-strings off

#
# Utilities
#

define run_and_exit
    catch throw
    python gdb.events.exited.connect(lambda x : gdb.execute("quit"))
    run
end

document run_and_exit
Runs the program and exits if no error occur.
end


################################################################################
# Electric Fence
#
# Debian's Electric Fence package provides efence as a shared library, which is
# very useful.
################################################################################

define efence
    set environment EF_PROTECT_BELOW 0
    set environment LD_PRELOAD /usr/lib/libefence.so.0.0
    echo Enabled Electric Fence\n
end
document efence
Enable memory allocation debugging through Electric Fence (efence(3)).
        See also nofence and underfence.
end


define underfence
    set environment EF_PROTECT_BELOW 1
    set environment LD_PRELOAD /usr/lib/libefence.so.0.0
    echo Enabled Electric Fence for undeflow detection\n
end
document underfence
Enable memory allocation debugging for underflows through Electric Fence 
(efence(3)).
        See also nofence and underfence.
end


define nofence
    unset environment LD_PRELOAD
    echo Disabled Electric Fence\n
end
document nofence
Disable memory allocation debugging through Electric Fence (efence(3)).
end


