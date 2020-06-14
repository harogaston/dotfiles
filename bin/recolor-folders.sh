#!/bin/bash
DIR=~/.local/share/icons/Suru++/places/scalable
cd $DIR
for filename in $DIR/*.svg; do
	linkz=$(readlink $filename)
	if [[ -n "$linkz" ]] && [[ "$linkz" =~ \-blue\- ]] ; then
		new_link=$(echo "$linkz" | sed 's/\-blue\-/-aurora-/g')
		ln -snfr $new_link $filename
	fi
done
