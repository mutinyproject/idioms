srcdir= $(readlink -f .)
SH = $(wildcard *.sh)
MAN = $(shell printf '%s\n' *.adoc | grep '.*\.[0-9a-z]*\.adoc')
HTML = $(MAN)

bindir ?= /usr/bin
datadir ?= /usr/share
mandir ?= $(datadir)/man
man1dir ?= $(mandir)/man1

.PHONY: all man html test check install clean

all: man

man: $(MAN:.adoc=)
html: $(HTML:.adoc=.html)

%.1: %.1.adoc AUTHORS
	asciidoctor -b manpage $< -o $@

%.html: %.adoc AUTHORS
	asciidoctor -b html5 $< -o $@

test: check
check: all
	test/test.sh "$(srcdir)"

install: all
	$(foreach sh,$(SH:.sh=), \
	    install -D -m 755 $(sh).sh $(DESTDIR)$(bindir)/$(sh); \
	)
	$(foreach man,$(MAN:.adoc=), \
	    install -D -m 644 $(man) $(DESTDIR)$(man1dir)/$(sh); \
	)

clean:
	rm -f $(MAN:.adoc=) $(HTML:.adoc=.html)
