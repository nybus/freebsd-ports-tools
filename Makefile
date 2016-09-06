# $Id: Makefile,v 1.10 2015/02/26 15:43:30 rmon Exp $

SVN=/opt/ports/svn

PORTS=/usr/local/ports

CVSROOT=svn://svn.freebsd.org

P5!=make -C ./tools/perl -V PERL5_DEFAULT

CF?=@base @sql @mail @www

TP=${.CURDIR}/w
PL=${TP}/l.txt

nop:

once:
	@if [ ! -e /etc/make.conf ]; then \
		install -v -p -m 444 ./etc/make.conf /etc; \
	fi
	@if [ ! -e /etc/make.conf.ports ]; then \
		ln -v -w -s ../opt/ports/etc/make.conf.ports /etc/make.conf.ports; \
	fi
	@if [ ! -e /etc/make.conf.d ]; then \
		ln -v -w -s ../opt/ports/etc/make.conf.d /etc/make.conf.d; \
	fi
	@if [ ! -e ${PORTS}/.svn ]; then \
		cd `dirname ${PORTS}` && ${SVN} co ${CVSROOT}/ports/head --depth files ports; \
	fi
	cd ${PORTS} && ${SVN} up Mk Templates Tools Keywords

boot0:
	make -C ./tools/ports fetchindex
	cd ${PORTS} && ${SVN} up Mk Templates Tools Keywords

boot1:
	cd ${PORTS} && ${SVN} up --depth files lang
	cd ${PORTS} && ${SVN} up --depth files ports-mgmt
#
	cd ${PORTS}/lang && ${SVN} up perl${P5}
	cd ${PORTS}/ports-mgmt && ${SVN} up pkg porteasy

boot2:
	BATCH=yes make -C ${PORTS}/lang/perl${P5} install clean DEPENDS_CLEAN=YES
	BATCH=yes make -C ${PORTS}/ports-mgmt/porteasy install clean DEPENDS_CLEAN=YES

boot3:
	cat patch/porteasy.patch | patch -b '' /usr/local/bin/porteasy
#
	BATCH=yes porteasy -v -a -r ${CVSROOT} -p ${PORTS} -u -b -e rsync-3
	BATCH=yes porteasy -v -a -r ${CVSROOT} -p ${PORTS} -u -b -e dialog4ports-0

boot: boot0 boot1 boot2 boot3

patch: .PHONY
	rsync -avPHx --exclude='CVS/' local/ /usr/ports/

engage:
	rm -rf ${TP}
	mkdir -p ${TP}
	cd cf && ${.CURDIR}/expand.pl ${CF} | sort | uniq > ${PL}

review:
	rm -rf ${TP}
	mkdir -p ${TP}
	pkg version -o -I -l '<' | awk '{print $$1;}' | sort > ${PL}
#	pkg version -v -I -l '<' | ./review.pl > ${PL}

audit0:
	rm -rf ${TP}
	mkdir -p ${TP}
audit1:
	pkg audit -q | xargs pkg info -q -o | sort > ${PL}
audit2:
	cat ${PL} | xargs pkg info -q -r | xargs pkg info -q -o | sort | uniq > ${PL}_
audit3:
	cat ${PL} ${PL}_ | sort | uniq | xargs pkg delete -y

up:
	cat ${PL} | ./join.pl | xargs -0 porteasy -v -r ${CVSROOT} -u

fetch:
	cat ${PL} | ./join.pl | xargs -0 porteasy -v -r ${CVSROOT} -f

build:
	cat ${PL} | ./join.pl | BATCH=yes xargs -0 porteasy -v -r ${CVSROOT} -b -C -e

rebuild:
	cat ${PL} | ./join.pl | BATCH=yes xargs -0 porteasy -v -r ${CVSROOT} -b -C

debug:
	cat ${PL} | ./join.pl | xargs -0 porteasy -v -r ${CVSROOT} -b -C -e

clean:
	cat ${PL} | ./join.pl | xargs -0 porteasy -v -c

wipe:
	pkg delete -a

step: engage up patch clean fetch build

istep: review up patch clean fetch rebuild

package:
	mkdir -p /usr/ports/packages/All
	cd /usr/ports/packages/All && pkg info | awk '{print $$1;}' | xargs -L 1 sh -c 'if [ ! -e $${0}.txz ]; then pkg create $$0; fi;'

refine:
	mkdir -p /usr/ports/packages/All-
	cd /usr/ports/packages/All && ls -1 | ${.CURDIR}/refine.pl | xargs -J % mv % ../All-/

repo:
	pkg repo /usr/ports/packages/All

.if exists(Makefile.local)
. include "Makefile.local"
.endif
