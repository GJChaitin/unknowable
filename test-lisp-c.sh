#!/bin/bash

okay=0
tmpdir="/tmp/"
is_okay=0
for program in *.l ; do
    short_outfile=${program/.l/.r}
    good_outfile=${tmpdir}${short_outfile}
    got_outfile=${tmpdir}${short_outfile}
    if cat ${program} | ./lisp ${program} >${got_outfile} && \
	    diff -w ${good_outfile} ${got_outfile}; then
	echo $program checked out okay
    else
	echo $program did not produce the same results
	is_okay=1
    fi
done
exit $is_okay
