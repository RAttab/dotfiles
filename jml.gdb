################################################################################
# JML
#
# Collection of useful JML gdb functions.
################################################################################

define jml
    help jml
end

document jml
    JML utility functions:
        jml_abort   - Turns on assertion aborts.
        jml_cvector - Prints a compact_vector
end


define jml_abort
    set env JML_ABORT = 1
end

document jml_abort
    Turns on the env var to triger a call to abort() whenever an assert is
    triggered.
end


define jml_cvector
    if $argc < 2
    help jml_cvector
    else
    if $arg0.is_internal_
        set $ptr = ($arg1*)(& $arg0.itl)
        set $size = $arg0.size_
        set $capacity = sizeof($arg0.itl.internal_) / sizeof($arg1)
    else
        set $ptr = $arg0.ext.pointer_
        set $size = $arg0.size_
        set $capacity = $arg0.ext.capacity_
    end
    end

    if $argc == 2
    set $start = 0
    set $end = $size
    end

    if $argc == 3
    set $start = $arg2
    set $end = $arg2 + 1
    end

    if $argc == 4
    set $start = $arg2
    set $end = $arg3
    end

    if $argc >= 2
    if $start < 0 || $start >= $size
        printf "start is out of bounds: %u >= %u\n", $start, $size
    else
        if $end <= 0 || $end > $size
        printf "end is out of bounds: %u > %u\n", $end, $size
        else
        set $i = $start
        while $i < $end
            printf "elem[%u]: ", $i
            p *($ptr + $i)
            set $i++
        end
        printf "compact_vector.isInternal = %u\n", $arg0.is_internal_
        printf "compact_vector.size = %u\n", $size
        printf "compact_vector.capacity = %u\n", $capacity

        end
    end
    end
end

document jml_cvector
    Prints the content of a compact_vector.

    Syntax: jml_cvector <vector> <type>
        Prints the entire array.

    Syntax: jml_cvector <vector> <type> <index>
        Prints the element at the given index.

    Syntax: jml_cvector <vector> <type> <start> <end>
        Prints the elements that fall within the given range.
end
