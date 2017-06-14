test -n "$srcdir" || srcdir=$(dirname "$0")
test -n "$srcdir" || srcdir=.
(
	cd "$srcdir" &&
	autoreconf -fiv -Wall
) || exit
test -n "$NOCONFIGURE" || "$srcdir/configure" "$@"
