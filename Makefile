srcdir= $(readlink -f .)
SH = $(wildcard *.sh)
MAN = $(shell printf '%s\n' *.adoc | grep '.*\.[0-9a-z]*\.adoc')
HTML = $(MAN)

ASCIIDOCTOR_OPTIONS := --attribute authors="$(shell cat AUTHORS)"

bindir ?= /usr/bin
datadir ?= /usr/share
mandir ?= $(datadir)/man
man1dir ?= $(mandir)/man1

all: man

man: $(MAN:.adoc=)
html: $(HTML:.adoc=.html)

%.1: %.1.adoc
	asciidoctor $(ASCIIDOCTOR_OPTIONS) -b manpage $< -o $@

%.html: %.adoc
	asciidoctor $(ASCIIDOCTOR_OPTIONS) -b html5 $< -o $@

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
