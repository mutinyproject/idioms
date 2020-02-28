name = idioms
version = 20200227

prefix ?= /usr/local
bindir ?= $(prefix)/bin
datadir ?= $(prefix)/share
libdir ?= $(prefix)/lib
mandir ?= $(datadir)/man
man1dir ?= $(mandir)/man1
man7dir ?= $(mandir)/man7

libdir := $(libdir)/$(name)

BINS := $(patsubst %.in, %, $(wildcard bin/*.in))
LIBS := $(patsubst %.in, %, $(wildcard lib/*.in))
MANS := $(patsubst %.adoc, %, $(wildcard man/*.adoc))
MAN1S := $(patsubst %.adoc, %, $(wildcard man/*.1.adoc))
MAN7S := $(patsubst %.adoc, %, $(wildcard man/*.7.adoc))
HTMLS := $(patsubst %.adoc, %.html, $(wildcard man/*.adoc))

INSTALLS := \
    $(addprefix $(DESTDIR)$(bindir)/,$(BINS:bin/%=%)) \
    $(addprefix $(DESTDIR)$(libdir)/,$(LIBS:lib/%=%)) \
    $(addprefix $(DESTDIR)$(man1dir)/,$(MAN1S:man/%=%)) \
    $(addprefix $(DESTDIR)$(man7dir)/,$(MAN7S:man/%=%))

.PHONY: all
all: bin lib man

.PHONY: clean
clean:
	rm -f $(BINS) $(LIBS) $(MANS) $(HTMLS)

.PHONY: install
install: $(INSTALLS)

.PHONY: lint
lint:
	printf '%s\n' $(patsubst %,%.in,$(BINS)) $(patsubst %,%.in,$(LIBS)) | xargs shellcheck

.PHONY: test
test: check

.PHONY: check
check: bin lib
	shellspec $(SHELLSPEC_FLAGS)

.PHONY: maint
maint: lint check

.PHONY: bin
bin: $(BINS)

.PHONY: lib
lib: $(LIBS)

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
	    -e "s|@@libdir@@|\$${IDIOMS_LIBDIR:-$(libdir)}|g" \
	    -e "s|@@mandir@@|$(mandir)|g" \
	    -e "s|@@man1dir@@|$(man1dir)|g" \
	    -e "s|@@man7dir@@|$(man7dir)|g" \
	    $< > $@.temp
	chmod +x $@.temp
	mv -f $@.temp $@

lib/%: lib/%.in
	sed \
	    -e "s|@@name@@|$(name)|g" \
	    -e "s|@@version@@|$(version)|g" \
	    -e "s|@@prefix@@|$(prefix)|g" \
	    -e "s|@@bindir@@|$(bindir)|g" \
	    -e "s|@@libdir@@|\$${IDIOMS_LIBDIR:-$(libdir)}|g" \
	    -e "s|@@mandir@@|$(mandir)|g" \
	    -e "s|@@man1dir@@|$(man1dir)|g" \
	    -e "s|@@man7dir@@|$(man7dir)|g" \
	    $< > $@.temp
	chmod +x $@.temp
	mv -f $@.temp $@

.DELETE_ON_ERROR: man/%.html
man/%.html: man/%.adoc man/footer.adoc.template
	asciidoctor --failure-level=WARNING -b html5 -B $(PWD) -d manpage -o $@ $<

.DELETE_ON_ERROR: man/%
man/%: man/%.adoc man/footer.adoc.template
	asciidoctor --failure-level=WARNING -b manpage -B $(PWD) -d manpage -o $@ $<

$(DESTDIR)$(bindir)/%: bin/%
	install -D $< $@

$(DESTDIR)$(libdir)/%: lib/%
	install -D -m 0644 $< $@

$(DESTDIR)$(man1dir)/%: man/%
	install -D -m 0644 $< $@

$(DESTDIR)$(man7dir)/%: man/%
	install -D -m 0644 $< $@

