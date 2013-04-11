#/*****************************************************************************\
#*                                                                             *
#*       Copyright (c) 2003, The Regents of the University of California       *
#*     See the file COPYRIGHT for a complete copyright notice and license.     *
#*                                                                             *
#*******************************************************************************
#*
#* CVS info:
#*   $RCSfile: Makefile,v $
#*   $Revision: 1.1.1.1.2.1 $
#*   $Date: 2010/05/11 21:25:16 $
#*   $Author: loewe6 $
#*
#* Purpose:
#*       Make mdtest executable.
#*
#*       make [mdtest]   -- mdtest
#*       make clean      -- remove executable
#*
#\*****************************************************************************/

CC.AIX = mpcc_r -bmaxdata:0x80000000
#CC.Linux = mpicc -Wall
#
# For Cray systems
CC.Linux = ${MPI_CC}
CC.Darwin = mpicc -Wall

# Requires GNU Make
OS=$(shell uname)

# Flags for compiling on 64-bit machines
LARGE_FILE = -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE=1 -D__USE_LARGEFILE64=1

# Flags for PLFS
#PLFS_FLAGS =
ifdef PLFS_CFLAGS
PLFS_FLAGS = -D_HAS_PLFS ${PLFS_CFLAGS} ${PLFS_LDFLAGS}
else
PLFS_FLAGS = -D_HAS_PLFS -I${MPICH_DIR}/include -lplfs
endif

CC = $(CC.$(OS))

all: mdtest

mdtest: mdtest.c
	$(CC) -D$(OS) $(LARGE_FILE) $(PLFS_FLAGS) -g -o mdtest mdtest.c -lm

clean:
	rm -f mdtest mdtest.o