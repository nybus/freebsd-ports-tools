# $Id: Makefile,v 1.1 2014/12/17 16:14:19 rmon Exp $

INDEXDIR!=make -C /usr/ports -V INDEXDIR

INDEXFILE!=make -C /usr/ports -V INDEXFILE

#FETCHINDEX=/usr/bin/env fetch -am -vvv -o
FETCHINDEX!=make -C /usr/ports -V FETCHINDEX

MASTER_SITE_INDEX!=make -C /usr/ports -V MASTER_SITE_INDEX

#fetchindex: ${INDEXDIR}/${INDEXFILE}.bz2
#	@bunzip2 < ${INDEXDIR}/${INDEXFILE}.bz2 > ${INDEXDIR}/${INDEXFILE} && chmod a+r ${INDEXDIR}/${INDEXFILE}
#	chmod a+r ${INDEXDIR}/${INDEXFILE} && ${RM} -f ${INDEXDIR}/${INDEXFILE}.bz2

fetchindex: ${INDEXDIR}/${INDEXFILE}

${INDEXDIR}/${INDEXFILE}: ${INDEXDIR}/${INDEXFILE}.bz2
	@bunzip2 < ${INDEXDIR}/${INDEXFILE}.bz2 > ${INDEXDIR}/${INDEXFILE} && chmod a+r ${INDEXDIR}/${INDEXFILE}

${INDEXDIR}/${INDEXFILE}.bz2: .PHONY
	@${FETCHINDEX} ${INDEXDIR}/${INDEXFILE}.bz2 ${MASTER_SITE_INDEX}${INDEXFILE}.bz2

#MASTER_SITE_INDEX?=     http://www.FreeBSD.org/ports/
#SETENV?=        /usr/bin/env
#FETCHINDEX?=    ${SETENV} ${FETCH_ENV} fetch -am -o
