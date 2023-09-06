# Makefile for Modules

include ../make.inc

# location of needed modules

# list of modules

MODULES = \
mp_bands.o \
mp_exx.o \
mp_global.o \
mp_images.o \
mp_pools.o \
mp_wave.o \
mp_world.o \
util_param.o \
mp_bands_util.o \
mp_base.o \
mp.o \
parallel_include.o \
io_global.o \
mp_diag.o \
command_line_options.o \
clocks_handler.o

OBJS = \
error_handler.o \
find_free_unit.o \
set_mpi_comm_4_cg.o \
set_mpi_comm_4_davidson.o \
la_error.o \
distools.o \
int_to_char.o \
cptimer.o


# list of subrooutines and functions (not modules) previously found in flib/

all : version version.o libqempi.a

## If no update_version is found, or it is not executable,
## just copy version.f90.in (that contains 'version=unknown').
## We use cat and not cp so that version.f90 has a new timestamp,
## forcing recompilation of version.f90.
## We use the inner if to avoid recompilation at each make.
version:
	- ( if test -x ../install/update_version ; then \
	../install/update_version; \
	else if test ! -f version.f90 ; then \
	cat version.f90.in > version.f90 ; fi ; fi )	

version.f90: version

## The following is needed only for lapack compiled from sources

dlamch.o : dlamch.f
	$(F77) $(FFLAGS_NOOPT) -c $<

libqempi.a: 	$(MODULES) $(OBJS)
	$(AR) $(ARFLAGS) $@ $?       
	$(RANLIB) $@    

tldeps :
	if test -n "$(TLDEPS)" ; then \
	( cd ../.. ; $(MAKE) $(TLDEPS) || exit 1 ) ; fi


clean :
	- /bin/rm -f *.o *.a *.d *.i *~ *_tmp.f90 *.mod *.L

# .PHONY forces execution of a rule irrespective of the presence of an
# updated file with the same name of the rule. In this way, the script 
# that generates version.f90 always runs, updating the version if you 
# execute "svn update". The update_version script takes care of not
# changing the file if the svn version did not change

.PHONY: version all clean

include make.depend
