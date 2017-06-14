bin_PROGRAMS = codav

codav_SOURCES = \
	codav.vala \
	group_header.vala \
	transaction.vala \
	transaction_list.vala \
	window.vala

AM_CPPFLAGS = \
	$(CODAV_CFLAGS) \
	-DLOCALEDIR=\""$(localedir)"\" \
	-DPKGDATADIR=\""$(pkgdatadir)"\" \
	-DPKGLIBDIR=\""$(pkglibdir)"\"

AM_VALAFLAGS = \
	@CODAV_PACKAGES@

codav_LDADD = \
	$(CODAV_LIBS)
