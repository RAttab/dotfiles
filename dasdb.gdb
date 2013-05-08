################################################################################
# DasDB
#
# Collection of useful DasDB gdb functions that makes looking around the region
# so much faster.
################################################################################


define dasdb
    help dasdb
end

document dasdb
    DasDB utility functions:
        dasdb_trie      - inspect a trie header in the mmap
        dasdb_node      - inspect a trie node in the mmap
        dasdb_dbn       - inspect a DenseBranchingNode mmap
        dasdb_trieptr   - equivalent of TriePtr::fromBits()
        dasdb_boff      - offset from TriePtr bits
        dasdb_poff      - offset from TriePtr object
        dasdb_region    - region bounds from an area
        dasdb_rstart    - region start from an area
        dasdb_rlen      - region length from an area
        dasdb_setup     - setup the debugging env for dasdb
end

define dasdb_setup
    handle SIGSEGV nostop
    jml_abort
end

document dasdb_setup
    Disables the normal signals issued by dasdb.
end

define dasdb_trie
    if $argc != 2
        help dasdb_trie
    else
        set $ptr = ($arg0) + (($arg1) + 6) * 0x40
        p/x $ptr
        p *((TrieBlock*)$ptr)
    end
end

document dasdb_trie
    Prints the root trie information for a given trie id.
    Syntax: dasdb_trie <region> <id>
end


define dasdb_node
    if $argc != 3
        help dasdb_node
    else
        set $ptr = ($arg0) + ($arg1)
        p/x $ptr
        p *(($arg2 *)$ptr)
    end
end

document dasdb_node
    Prints the content of a node at the given offset.
    Syntax dasdb_node <region> <offset> <type>
end

define dasdb_dbn
    if $argc != 2
        help dasdb_node
    else
        dasdb_node $arg0 $arg1 DenseBranchingNodeRepr

        set $dbn = *((DenseBranchingNodeRepr *)(($arg0) + ($arg1)))

        if $dbn.numBits > 1
            set $storagePtr = (DenseBranchingNodeBranch*) (($arg0) + $dbn.storageOffset)

        else
            set $storagePtr = (DenseBranchingNodeBranch*) (($arg0) + ($arg1) + 32)
        end

        set $i = 0
        while $i < (1 << $dbn.numBits)
            if ($storagePtr + $i).size > 0
                printf "branch[%u]: ", $i
                p *($storagePtr + $i)
            end
            set $i++
        end
    end
end

document dasdb_dbn
    Prints the content of a DenseBranchingNode at the given offset.
    Syntax dasdb_dbn <region> <offset>
end


define dasdb_trieptr
    if $argc > 1
        help dasdb_trieptr
    else
        set $ptr = (TriePtr*) malloc(sizeof(TriePtr))
        p $ptr

        if $argc == 1
            set $ptr->bits = $arg0
            p *$ptr
        else
            set $ptr->bits = 0
        end
    end
end

document dasdb_trieptr
    Allocates a new trie ptr object with the given bits
    Syntax: dasdb_trieptr <bits>
end



define dasdb_boff
    if $argc == 0
        help dasdb_boff
    else
        p/x (($arg0) >> 7) << 6
    end
end

document dasdb_boff
    Gets a usable off from the a TriePtr bits representation
    Syntax: dasdb_boff <bits>
end


define dasdb_poff
    if $argc == 0
        help dasdb_poff
    else
        p/x ($arg0).data << 6
    end
end

document dasdb_poff
    Gets a usable off from the a TriePtr
    Syntax: dasdb_poff <trieptr>
end


define dasdb_region
    if $argc == 0
        help dasdb_region
    else
        p ($arg0).region_.data
    end
end

document dasdb_region
    Prints the bounds of the region for a given memory allocator.
    Syntax: dasdb_region <area>
    area is assumed to be a reference and not a pointer.
end


define dasdb_rstart
    if $argc == 0
        help dasdb_region
    else
        p ($arg0).region_.data.start
    end
end

document dasdb_rstart
    Prints the start of a region
    Syntax: dasdb_region <area>
    area is assumed to be a reference and not a pointer.
end


define dasdb_rlen
    if $argc == 0
        help dasdb_region
    else
        p ($arg0).region_.data.length
    end
end

document dasdb_rstart
    Prints the length of a region
    Syntax: dasdb_region <area>
    area is assumed to be a reference and not a pointer.
end
