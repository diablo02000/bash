#!/bin/bash

source ../compare-version.sh


## Check if 2.0 et newer than 2.1
v1="2.0"
v2="2.1"
if $(is_newer ${v1} ${v2});
then
	echo -e "${v1} > ${v2}"
else
	echo -e "${v1} < ${v2}"
fi

# Check if 2.0.1 et older than 2.1.2
v1="2.0.1"
v2="2.1.2"
if is_older ${v1} ${v2};
then
	echo -e "${v1} < ${v2}"
else
	echo -e "${v1} > ${v2}"
fi

# Check if 2.2.2-rc.1 et older than 2.2.2-rc.2
v1="2.2.2-rc.1"
v2="2.2.2-rc.2"
if is_newer ${v1} ${v2};
then
	echo -e "${v1} > ${v2}"
else
	echo -e "${v1} < ${v2}"
fi

# Check if 2.2 and 2.2.0 are equal
v1="2.2"
v2="2.2.0"
if is_equal ${v1} ${v2};
then
	echo -e "${v1} == ${v2}"
else
	echo -e "${v1} != ${v2}"
fi
