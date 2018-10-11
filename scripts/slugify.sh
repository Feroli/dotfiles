#!/usr/bin/env sh

# author: tpx

# can be used to generate git branch names

# lowercase
# remove special characters
# replace spaces with -
# squash repeating -

# sample usage
# git checkout -b $(slugify RAE 123 - implement everything)

slugify() {
	input=$*

	echo $input | tr -dc '[:alnum:] \n-' | tr '[:upper:]' '[:lower:]' | tr ' ' - | tr -s -
}

slugify $*
