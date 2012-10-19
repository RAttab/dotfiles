################################################################################
# DasDB
#
# Collection of useful DasDB gdb functions that makes looking around the region
# so much faster.
################################################################################

define runFreq
    run --router-uri=tcp://ag4.recoset.com:9975 --subscription-uri=tcp://ag4.recoset.com:9973 --carbon-prefix=test 1> freq.txt
end


define dasdb
    help dasdb
end

document dasdb
    DasDB utility functions:
        dasdb_trie	- inspect a trie header in the mmap
        dasdb_node	- inspect a trie node in the mmap
        dasdb_trieptr	- equivalent of TriePtr::fromBits()
        dasd_boff       - offset from TriePtr bits
        dasd_poff       - offset from TriePtr object
        dasdb_region	- region bounds from an area
        dasdb_rstart	- region start from an area
        dasdb_rlen	- region length from an area
end

define dasdb_trie
    if $argc != 2
	help dasdb_trie
    end

    set $ptr = ($arg0) + (($arg1) + 6) * 0x40
    p/x $ptr
    p *((TrieBlock*)$ptr)
end

document dasdb_trie
    Prints the root trie information for a given trie id.
    Syntax: dasdb_trie <region> <id>
end


define dasdb_node
    if $argc != 3
	help dasdb_node
    end

    set $ptr = ($arg0) + ($arg1)
    p/x $ptr
    p *(($arg2 *)$ptr)
end

document dasdb_node
    Prints the content of a node at the given offset.
    Syntax dasdb_node <region> <offset> <type>
end


define dasdb_trieptr
    if $argc == 0
	help dasdb_trieptr
    end

    call malloc(sizeof(TriePtr))
    set ((TriePtr*)($1))->bits = $arg0
    p *((TriePtr*)($1))
end

document dasdb_trieptr
    Allocates a new trie ptr object with the given bits
    Syntax: dasdb_trieptr <bits>
end



define dasdb_boff
    if $argc == 0
	help dasdb_boff
    end

    p/x (($arg0) >> 7) << 6
end

document dasdb_boff
    Gets a usable off from the a TriePtr bits representation
    Syntax: dasdb_boff <bits>
end


define dasdb_poff
    if $argc == 0
	help dasdb_poff
    end

    p/x ($arg0).data << 6
end

document dasdb_poff
    Gets a usable off from the a TriePtr
    Syntax: dasdb_poff <trieptr>
end


define dasdb_region
    if $argc == 0
	help dasdb_region
    end

    p ($arg0).region_.data
end

document dasdb_region
    Prints the bounds of the region for a given memory allocator.
    Syntax: dasdb_region <area>
    area is assumed to be a reference and not a pointer.
end


define dasdb_rstart
    if $argc == 0
	help dasdb_region
    end

    p ($arg0).region_.data.start
end

document dasdb_rstart
    Prints the start of a region
    Syntax: dasdb_region <area>
    area is assumed to be a reference and not a pointer.
end


define dasdb_rlen
    if $argc == 0
	help dasdb_region
    end

    p ($arg0).region_.data.length
end

document dasdb_rstart
    Prints the length of a region
    Syntax: dasdb_region <area>
    area is assumed to be a reference and not a pointer.
end
