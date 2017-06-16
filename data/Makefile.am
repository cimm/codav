desktopdir = $(datadir)/applications
desktop_in_in_files = codav.desktop.in.in
desktop_in_files = $(desktop_in_in_files:.desktop.in.in=.desktop.in)
desktop_DATA = $(desktop_in_files:.desktop.in=.desktop)

appdatadir = $(datadir)/appdata
appdata_in_files = codav.appdata.xml.in
appdata_DATA = $(appdata_in_files:.xml.in=.xml)

EXTRA_DIST = \
	$(desktop_in_in_files) \
	$(desktop_in_files) \
	$(desktop_DATA) \
	$(appdata_in_files) \
	$(appdata_DATA) \
	$(NULL)

DISTCLEANFILES = \
	$(desktop_in_files) \
	$(desktop_DATA) \
	$(appdata_DATA) \
	$(NULL)
