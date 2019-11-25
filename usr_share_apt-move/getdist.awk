# getdist --- Get Debian component name from a section string.
#
# Copyright (c) 2002 Herbert Xu <herbert@debian.org>
# $Id: getdist.awk,v 1.4 2003/03/25 09:02:13 herbert Exp $

function getdist(section, dist, a) {
	if (section in _getdist) {
		return _getdist[section]
	}

	dist = section
	ldist = tolower(dist)

	if (match(ldist, /^non-us\/[^\/]*/)) {
		dist = "non-US" substr(dist, 7, RLENGTH - 6)
	} else if (ldist == "non-us") {
		dist = "non-US/main"
	} else if (match(dist, /^[^\/]*\//)) {
		dist = substr(dist, 1, RLENGTH - 1)
	} else {
		dist = "main"
	}

	return _getdist[section] = dist
}
