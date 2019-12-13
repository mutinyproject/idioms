srcdir= $(readlink -f .)
SH = $(wildcard *.sh)
MAN = $(shell printf '%s\n' *.adoc | grep '.*\.[0-9a-z]*\.adoc')

bindir ?= /usr/bin
datadir ?= /usr/share
mandir ?= $(datadir)/man
man1dir ?= $(mandir)/man1

all: $(MAN:.adoc=)

%.1: %.1.adoc
	asciidoctor -b manpage $< -o $@

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
	rm -f $(MAN:.adoc=)
