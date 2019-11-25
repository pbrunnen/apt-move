# cmpbignum --- compare two arbitrarily long integers.
#	The function returns:
#		< 0 if a < b
#		== 0 if a == b
#		> 0 if a > b
#	The idea came from Anthony Towns in http://bugs.debian.org/92839.
#
# Copyright (c) 2001 Herbert Xu <herbert@debian.org>
# $Id: cmpbignum.awk,v 1.1 2002/01/25 08:47:24 herbert Exp $

function cmpbignum(a, b, i, j, k, l, d) {
	i = match(a, /[^0]/)
	j = match(b, /[^0]/)
	if (!i || !j) {
		return !!i - !!j
	}

	k = length(a)
	l = length(b)
	d = (k - i) - (l - j)
	if (d) {
		return d
	}

	do {
		d = substr(a, i, 1) - substr(b, j, 1)
		if (d) {
			return d
		}
		i++
		j++
	} while (i <= k)

	return 0
}
