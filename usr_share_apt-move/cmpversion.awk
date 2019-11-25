# cmpversion --- compare versions of Debian packages.
#	The function returns:
#		< 0 if a < b
#		== 0 if a == b
#		> 0 if a > b
#	This function depends on cmpbignum.
#
# Copyright (c) 2001 Herbert Xu <herbert@debian.org>
# $Id: cmpversion.awk,v 1.3 2006/12/06 02:49:29 herbert Exp $

function _cmpversion_segment(a, b, i, j, k, l, m, n, p, q, d) {
	k = length(a)
	l = length(b)

	while (k > 0 && l > 0) {
		i = match(a, /[0-9]/)
		if (!i) {
			i = k + 1
		}
		j = match(b, /[0-9]/)
		if (!j) {
			j = l + 1
		}

		m = 1
		n = 1
		while (m < i && n < j) {
			p = substr(a, m, 1)
			if (p == "~") {
				p = "!"
			}
			q = substr(b, n, 1)
			if (q == "~") {
				q = "!";
			}
			d = (p ~ /[A-Za-z]/) - (q ~ /[A-Za-z]/)
			if (d) {
				return d
			}
			if (p != q) {
				return p < q ? -1 : 1
			}
			m++
			n++
		}

		d = (m < i) - (n < j)
		if (d) {
			return d
		}

		a = substr(a, i)
		b = substr(b, j)
		k -= i - 1
		l -= j - 1
		if (k <= 0 || l <= 0) {
			break
		}

		i = match(a, /[^0-9]/)
		if (!i) {
			i = k + 1
		}
		j = match(b, /[^0-9]/)
		if (!j) {
			j = l + 1
		}

		d = cmpbignum(substr(a, 1, i - 1), substr(b, 1, j - 1))
		if (d) {
			return d
		}

		a = substr(a, i)
		b = substr(b, j)
		k -= i - 1
		l -= j - 1
	}

	if (k <= 0) {
		a = "0";
	}
	if (l <= 0) {
		b = "0";
	}
	a = substr(a, 1, 1);
	b = substr(b, 1, 1);
	d = (b ~ /~/) - (a ~ /~/);
	if (d) {
		return d;
	}
	return (k > 0) - (l > 0)
}

function cmpversion(a, b, i, j, k, l, d) {
	if (a == b) {
		return 0
	} else if (a == "-") {
		return 1
	} else if (b == "-") {
		return -1
	}

	i = index(a, ":")
	j = index(b, ":")
	if (i > 1 || j > 1) {
		d = (i > 1) - (j > 1)
		if (d) {
			return d
		}
		d = cmpbignum(substr(a, 1, i - 1), substr(b, 1, j - 1))
		if (d) {
			return d
		}
		i++
		j++
	} else {
		i = 1
		j = 1
	}

	a = substr(a, i)
	b = substr(b, j)
	k = match(a, /.*-/)
	if (k) {
		k = RLENGTH - 1
		i = k + 2
	} else {
		k = length(a)
		i = k + 1
	}
	l = match(b, /.*-/)
	if (l) {
		l = RLENGTH - 1
		j = l + 2
	} else {
		l = length(b)
		j = l + 1
	}

	d = _cmpversion_segment(substr(a, 1, k), substr(b, 1, l))
	if (d) {
		return d
	}
	return _cmpversion_segment(substr(a, i), substr(b, j))
}
