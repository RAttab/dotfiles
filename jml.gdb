define jml_cvector
    if $argc != 2
	help jml_cvector
    else
	if $arg0.is_internal_
	    set $ptr = ($arg1*)(& $arg0.itl)
	else
	    set $ptr = $arg0.ext.pointer_
	end

	set $i = 0
	while $i < $arg0.size_
	    printf "elem[%u]: ", $i
	    p *($ptr + $i)
	    set $i++
	end
    end
end

document jml_cvector
    Prints the content of a compact_vector.
    Syntax jml_cvector <vector> <type>
end