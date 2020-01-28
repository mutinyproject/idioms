name = idioms
version = 20200128

prefix ?=
bindir ?= $(prefix)/bin
datadir ?= $(prefix)/share
mandir ?= $(datadir)/man
man1dir ?= $(mandir)/man1

BINS := $(patsubst %.in, %, $(shell find bin/ -name '*.in'))
MAN1S := $(patsubst %.adoc, %, $(wildcard man/*.1.adoc))
HTMLS := $(patsubst %.adoc, %.html, $(wildcard man/*.adoc))
MANS := $(MAN1S)

INSTALLS := \
	$(addprefix $(DESTDIR)$(bindir)/,$(BINS:bin/%=%)) \
	$(addprefix $(DESTDIR)$(man1dir)/,$(MAN1S:man/%=%))

.PHONY: all
all: bin man

.PHONY: clean
clean:
	rm -f $(BINS) $(LIBS) $(MANS) $(HTMLS)

.PHONY: install
install: $(INSTALLS)

.PHONY: test check
test: check

check: all
	test/test.sh

.PHONY: bin
bin: $(BINS)

.PHONY: man
man: $(MANS)

.PHONY: html
html: $(HTMLS)

bin/%: bin/%.in
	sed \
		-e "s|@@name@@|$(name)|g" \
		-e "s|@@version@@|$(version)|g" \
		-e "s|@@prefix@@|$(prefix)|g" \
		-e "s|@@bindir@@|$(bindir)|g" \
		$< > $@
	chmod +x $@

.DELETE_ON_ERROR: man/%
man/%.html: man/%.adoc
	asciidoctor --failure-level=WARNING -b html5 -B $(PWD) -o $@ $<

.DELETE_ON_ERROR: man/%
man/%: man/%.adoc
	asciidoctor --failure-level=WARNING -b manpage -B $(PWD) -d manpage -o $@ $<

$(DESTDIR)$(bindir)/%: bin/%
	install -D $< $@

$(DESTDIR)$(man1dir)/%: man/%
	install -D $< $@

