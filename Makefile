name = idioms
version = 20200614

prefix ?= /usr/local
bindir ?= ${prefix}/bin
datadir ?= ${prefix}/share
libdir ?= ${prefix}/lib
mandir ?= ${datadir}/man
man1dir ?= ${mandir}/man1
man3dir ?= ${mandir}/man3

ASCIIDOCTOR ?= asciidoctor
ASCIIDOCTOR_FLAGS := --failure-level=WARNING
ASCIIDOCTOR_FLAGS += -a manmanual="Mutineer's Guide - ${name}"
ASCIIDOCTOR_FLAGS += -a mansource="Mutiny"

SHELLCHECK ?= shellcheck

SHELLSPEC ?= shellspec
SHELLSPEC_FLAGS ?= --format tap

-include config.mk

libdir := ${libdir}/${name}

BINS = \
    backslash \
    idioms \
    integer \
    lastarg \
    match

LIBS = \
    idioms.sh

MAN1 = ${BINS:=.1}
MAN3 = ${LIBS:.sh=.3}
MAN7 = \
    idioms.7

MANS = ${MAN1} ${MAN3} ${MAN7}
HTMLS = ${MANS:=.html}

all: FRC ${BINS} ${LIBS} ${MANS}
dev: FRC README all lint check

bin: FRC ${BINS}
lib: FRC ${LIBS}
man: FRC ${MANS}
html: FRC ${HTMLS}

# NOTE: disable built-in rules which otherwise mess up creating .sh files
.SUFFIXES:

# ${IDIOMS_LIBDIR} is used to allow for testing prior to installation.
.SUFFIXES: .in
.in:
	sed \
	    -e "s|@@name@@|${name}|g" \
	    -e "s|@@version@@|${version}|g" \
	    -e "s|@@prefix@@|${prefix}|g" \
	    -e "s|@@bindir@@|${bindir}|g" \
	    -e "s|@@libdir@@|\$${IDIOMS_LIBDIR:-${libdir}}|g" \
	    -e "s|@@mandir@@|${mandir}|g" \
	    -e "s|@@man1dir@@|${man1dir}|g" \
	    -e "s|@@man3dir@@|${man3dir}|g" \
	    $< > $@
	chmod +x $@

.sh:
	sed \
	    -e "s|@@name@@|${name}|g" \
	    -e "s|@@version@@|${version}|g" \
	    -e "s|@@prefix@@|${prefix}|g" \
	    -e "s|@@bindir@@|${bindir}|g" \
	    -e "s|@@libdir@@|\$${IDIOMS_LIBDIR:-${libdir}}|g" \
	    -e "s|@@mandir@@|${mandir}|g" \
	    -e "s|@@man1dir@@|${man1dir}|g" \
	    -e "s|@@man3dir@@|${man3dir}|g" \
	    $< > $@

.SUFFIXES: .adoc
.html.adoc:
	${ASCIIDOCTOR} ${ASCIIDOCTOR_FLAGS} -b html5 -d manpage -o $@ $<

.adoc:
	${ASCIIDOCTOR} ${ASCIIDOCTOR_FLAGS} -b manpage -d manpage -o $@ $<

install: FRC all
	install -d \
	    ${DESTDIR}${bindir} \
	    ${DESTDIR}${libdir} \
	    ${DESTDIR}${mandir} \
	    ${DESTDIR}${man1dir} \
	    ${DESTDIR}${man3dir}

	for bin in ${BINS}; do install -m0755 $${bin} ${DESTDIR}${bindir}; done
	for lib in ${LIBS}; do install -m0644 $${lib} ${DESTDIR}${libdir}; done
	for man1 in ${MAN1}; do install -m0644 $${man1} ${DESTDIR}${man1dir}; done
	for man3 in ${MAN3}; do install -m0644 $${man3} ${DESTDIR}${man3dir}; done

clean: FRC
	rm -f ${BINS} ${LIBS} ${MANS} ${HTMLS}

README: idioms.7
	man ./$< | col -bx > README

lint: FRC ${BINS} ${LIBS}
	${SHELLCHECK} ${BINS:=.in} ${LIBS:=.in}

check: FRC ${BINS} ${LIBS}
	${SHELLSPEC} ${SHELLSPEC_FLAGS}

FRC:
